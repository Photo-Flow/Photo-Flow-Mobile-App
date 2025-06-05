import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:photo_flow_mobile_app/modules/profile/pages/user_profile/cubit/user_profile_cubit.dart';
import 'package:photo_flow_mobile_app/shared/components/button/button_component.dart';
import 'package:photo_flow_mobile_app/shared/components/button/second_button_component.dart';
import 'package:photo_flow_mobile_app/shared/components/card/card_feed_component.dart';
import 'package:photo_flow_mobile_app/shared/components/loading/loading_component.dart';
import 'package:photo_flow_mobile_app/shared/components/profile/profile_image_widget.dart';
import 'package:photo_flow_mobile_app/shared/components/profile/profile_stats_widget.dart';
import 'package:photo_flow_mobile_app/shared/components/profile/post_grid_widget.dart';
import 'package:photo_flow_mobile_app/shared/models/post_model.dart';
import 'package:photo_flow_mobile_app/shared/utils/colors/photo_flow_colors.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;
  final bool showBackButton;

  const UserProfilePage({
    super.key,
    required this.userId,
    this.showBackButton = true,
  });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late final UserProfileCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = GetIt.instance.get<UserProfileCubit>();
    cubit.loadUserProfile(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhotoFlowColors.photoFlowBackground,      appBar: AppBar(
        backgroundColor: PhotoFlowColors.photoFlowBackground,
        elevation: 0,
        automaticallyImplyLeading: widget.showBackButton,
        leading: widget.showBackButton 
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () => _showOptionsMenu(context),
          ),
        ],
      ),
      body: BlocBuilder<UserProfileCubit, UserProfileState>(
        bloc: cubit,
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => cubit.refreshProfile(widget.userId),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: _buildBody(state),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(UserProfileState state) {
    switch (state) {
      case UserProfileLoadingState():
        return const SizedBox(
          height: 400,
          child: Center(child: LoadingComponent()),
        );

      case UserProfileLoadedState():
        return _buildProfileContent(state);      case UserProfileFollowingState():
        // Durante o processo de follow, mantém o estado anterior se disponível
        final previousState = cubit.state;
        if (previousState is UserProfileLoadedState) {
          return _buildProfileContent(previousState, isFollowLoading: true);
        }
        return const SizedBox(
          height: 400,
          child: Center(child: LoadingComponent()),
        );

      case UserProfileErrorState():
        return _buildErrorState(state.message);

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildProfileContent(
    UserProfileLoadedState state, {
    bool isFollowLoading = false,
  }) {
    final profile = state.profile;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header do perfil
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto de perfil e estatísticas
              Row(
                children: [
                  ProfileImageWidget(
                    imageUrl: profile.profileImageUrl,
                    size: 90,
                    onTap: profile.profileImageUrl != null
                        ? () => _showProfileImageFullScreen(profile.profileImageUrl!)
                        : null,
                  ),
                  const SizedBox(width: 20),                  
                  Expanded(
                    child: ProfileStatsWidget(
                      postsCount: state.posts.length, // Conta os posts reais
                      followersCount: profile.followersCount,
                      followingCount: profile.followingCount,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Nome e verificação
              Row(
                children: [
                  Text(
                    profile.displayName ?? profile.email.split('@').first,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (profile.isVerified) ...[
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.verified,
                      size: 18,
                      color: Colors.blue,
                    ),
                  ],
                ],
              ),
              
              // Bio
              if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  profile.bio!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
              
              const SizedBox(height: 16),
              
              // Botões de ação
              _buildActionButtons(state, isFollowLoading),
            ],
          ),
        ),
        
        // Divisor
        Container(
          height: 1,
          color: PhotoFlowColors.photoFlowInputBackground,
        ),
        
        // Grid de posts
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: PostGridWidget(
            posts: state.posts,
            onPostTap: _showPostDetail,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    UserProfileLoadedState state,
    bool isFollowLoading,
  ) {
    if (state.isOwnProfile) {
      return Row(
        children: [
          Expanded(
            child: ButtonComponent(
              title: 'Editar Perfil',
              onTap: () => _navigateToEditProfile(),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: ButtonComponent(
              title: state.isFollowing ? 'Seguindo' : 'Seguir',
              isLoading: isFollowLoading,
              onTap: () => cubit.toggleFollow(widget.userId),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SecondButtonComponent(
              title: 'Mensagem',
              onTap: () => _sendMessage(),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildErrorState(String message) {
    return SizedBox(
      height: 400,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: PhotoFlowColors.photoFlowTextSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar perfil',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: PhotoFlowColors.photoFlowTextSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ButtonComponent(
              title: 'Tentar Novamente',
              onTap: () => cubit.loadUserProfile(widget.userId),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: PhotoFlowColors.photoFlowInputBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share, color: Colors.white),
              title: const Text('Compartilhar Perfil', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _shareProfile();
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy, color: Colors.white),
              title: const Text('Copiar Link', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _copyProfileLink();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileImageFullScreen(String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _showPostDetail(PostModel post) {
    // Obter dados do usuário atual do estado
    final currentState = cubit.state;
    if (currentState is! UserProfileLoadedState) return;
    
    final profile = currentState.profile;
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header do dialog com botão fechar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Card do post
                CardFeedComponent(
                  userName: profile.displayName ?? profile.email.split('@').first,
                  profileImageUrl: profile.profileImageUrl ?? '',
                  feedImageUrl: post.imageUrl,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToEditProfile() {
    // Implementar navegação para edição de perfil
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edição de perfil em desenvolvimento')),
    );
  }
  // void _navigateToSettings() {
  //   // Implementar navegação para configurações
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Configurações em desenvolvimento')),
  //   );
  // }

  void _sendMessage() {
    // Implementar funcionalidade de mensagem
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mensagens em desenvolvimento')),
    );
  }

  void _shareProfile() {
    // Implementar compartilhamento de perfil
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Compartilhamento em desenvolvimento')),
    );
  }

  void _copyProfileLink() {
    // Implementar cópia do link do perfil
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link copiado!')),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
