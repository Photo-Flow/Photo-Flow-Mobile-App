import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_flow_mobile_app/modules/profile/providers/user_profile_provider.dart';
import 'package:photo_flow_mobile_app/shared/models/user_profile_model.dart';
import 'package:photo_flow_mobile_app/shared/models/post_model.dart';
import 'package:photo_flow_mobile_app/shared/controllers/account_info/account_info_controller.dart';

part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final UserProfileProvider _userProfileProvider;
  final AccountInfoController _accountInfoController;

  UserProfileCubit({
    required UserProfileProvider userProfileProvider,
    required AccountInfoController accountInfoController,
  })  : _userProfileProvider = userProfileProvider,
        _accountInfoController = accountInfoController,
        super(const UserProfileInitialState());

  Future<void> loadUserProfile(String userId) async {
    emit(const UserProfileLoadingState());

    try {
      final currentUser = _accountInfoController.getUser();
      final isOwnProfile = currentUser?.id == userId;
      
      final profile = await _userProfileProvider.getUserProfile(userId);
      final posts = await _userProfileProvider.getUserPosts(userId);
      
      bool isFollowing = false;
      if (!isOwnProfile && currentUser != null) {
        isFollowing = await _userProfileProvider.isFollowing(currentUser.id, userId);
      }

      emit(UserProfileLoadedState(
        profile: profile,
        posts: posts,
        isFollowing: isFollowing,
        isOwnProfile: isOwnProfile,
      ));
    } catch (e) {
      emit(UserProfileErrorState(message: e.toString()));
    }
  }

  Future<void> toggleFollow(String targetUserId) async {
    if (state is! UserProfileLoadedState) return;

    final currentState = state as UserProfileLoadedState;
    final currentUser = _accountInfoController.getUser();
    
    if (currentUser == null) return;

    emit(const UserProfileFollowingState());

    try {
      if (currentState.isFollowing) {
        await _userProfileProvider.unfollowUser(currentUser.id, targetUserId);
      } else {
        await _userProfileProvider.followUser(currentUser.id, targetUserId);
      }

      // Recarregar o perfil para atualizar os dados
      await loadUserProfile(targetUserId);
    } catch (e) {
      emit(UserProfileErrorState(message: e.toString()));
    }
  }

  Future<void> refreshProfile(String userId) async {
    await loadUserProfile(userId);
  }
}
