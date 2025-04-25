import 'package:photo_flow_mobile_app/modules/auth/models/user_model.dart';

abstract class AuthProvider {
  Future<UserModel> login({required String email, required String password});

  Future<void> register({required String email, required String password});
}
