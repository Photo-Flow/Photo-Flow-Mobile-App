import 'package:firebase_auth/firebase_auth.dart';
import 'package:photo_flow_mobile_app/modules/auth/models/user_model.dart';

class AuthProvider {
  final FirebaseAuth firebaseAuth;

  AuthProvider({required this.firebaseAuth});

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return UserModel(
        id: result.user!.uid,
        email: result.user!.email!,
      );
    } catch (e) {
      throw Exception('Error logging in: $e');
    }
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Error creating user: $e');
    }
  }
}
