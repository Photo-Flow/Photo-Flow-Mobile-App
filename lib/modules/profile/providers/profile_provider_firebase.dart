import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

import 'package:photo_flow_mobile_app/shared/models/user_model.dart';
import 'package:photo_flow_mobile_app/modules/profile/providers/profile_provider.dart';

class ProfileProviderFirebase implements ProfileProvider {
  final FirebaseAuth firebaseAuth;

  ProfileProviderFirebase({required this.firebaseAuth});

  @override
  Future<UserModel> update({
    required String email,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final user = firebaseAuth.currentUser;

      if (user == null) {
        throw Exception('Usuário não está logado');
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      await user.verifyBeforeUpdateEmail(email);

      await user.updatePassword(newPassword);

      return UserModel(id: user.uid, email: email);
    } catch (e) {
      throw Exception('Erro ao atualizar credenciais: $e');
    }
  }
}
