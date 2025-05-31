import 'package:photo_flow_mobile_app/shared/models/user_model.dart';

abstract class ProfileProvider {
  Future<UserModel> update({
    required String email,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });
}
