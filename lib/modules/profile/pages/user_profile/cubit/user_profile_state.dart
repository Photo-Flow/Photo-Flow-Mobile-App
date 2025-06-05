part of 'user_profile_cubit.dart';

sealed class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object?> get props => [];
}

final class UserProfileInitialState extends UserProfileState {
  const UserProfileInitialState();
}

final class UserProfileLoadingState extends UserProfileState {
  const UserProfileLoadingState();
}

final class UserProfileLoadedState extends UserProfileState {
  final UserProfileModel profile;
  final List<PostModel> posts;
  final bool isFollowing;
  final bool isOwnProfile;

  const UserProfileLoadedState({
    required this.profile,
    required this.posts,
    required this.isFollowing,
    required this.isOwnProfile,
  });

  @override
  List<Object?> get props => [profile, posts, isFollowing, isOwnProfile];
}

final class UserProfileErrorState extends UserProfileState {
  final String message;

  const UserProfileErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

final class UserProfileFollowingState extends UserProfileState {
  const UserProfileFollowingState();
}
