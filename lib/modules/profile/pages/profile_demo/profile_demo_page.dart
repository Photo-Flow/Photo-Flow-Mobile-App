import 'package:flutter/material.dart';
import 'package:photo_flow_mobile_app/modules/profile/pages/user_profile/user_profile_page.dart';
import 'package:photo_flow_mobile_app/shared/components/button/button_component.dart';
import 'package:photo_flow_mobile_app/shared/utils/colors/photo_flow_colors.dart';

class ProfileDemoPage extends StatelessWidget {
  const ProfileDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhotoFlowColors.photoFlowBackground,
      appBar: AppBar(
        title: Image.asset('assets/Logo.png'),
        centerTitle: true,
        backgroundColor: PhotoFlowColors.photoFlowBackground,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Demo do Perfil de Usuário',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Página de perfil inspirada no Instagram com:',
              style: TextStyle(
                fontSize: 16,
                color: PhotoFlowColors.photoFlowTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FeatureItem(text: '• Foto de perfil com zoom'),
                _FeatureItem(text: '• Estatísticas (posts, seguidores, seguindo)'),
                _FeatureItem(text: '• Bio e nome de usuário'),
                _FeatureItem(text: '• Grid de fotos estilo Instagram'),
                _FeatureItem(text: '• Botões de seguir/editar perfil'),
                _FeatureItem(text: '• Menu de opções'),
                _FeatureItem(text: '• Refresh para atualizar'),
              ],
            ),
            const SizedBox(height: 40),
            ButtonComponent(
              title: 'Ver Meu Perfil',
              onTap: () => _navigateToProfile(context, 'current_user_id'),
            ),
            const SizedBox(height: 16),
            ButtonComponent(
              title: 'Ver Perfil de Outro Usuário',
              onTap: () => _navigateToProfile(context, 'other_user_id'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToProfile(BuildContext context, String userId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserProfilePage(userId: userId),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String text;

  const _FeatureItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }
}
