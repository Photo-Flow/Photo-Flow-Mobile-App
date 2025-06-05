import 'package:photo_flow_mobile_app/shared/models/user_profile_model.dart';
import 'package:photo_flow_mobile_app/shared/models/post_model.dart';

abstract class UserProfileProvider {
  Future<UserProfileModel> getUserProfile(String userId);
  Future<List<PostModel>> getUserPosts(String userId);
  Future<void> updateProfile({
    required String userId,
    String? displayName,
    String? bio,
    String? profileImageUrl,
  });
  Future<void> followUser(String currentUserId, String targetUserId);
  Future<void> unfollowUser(String currentUserId, String targetUserId);
  Future<bool> isFollowing(String currentUserId, String targetUserId);
}
