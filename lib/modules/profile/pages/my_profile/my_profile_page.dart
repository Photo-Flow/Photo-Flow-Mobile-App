import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:photo_flow_mobile_app/modules/profile/pages/user_profile/user_profile_page.dart';
import 'package:photo_flow_mobile_app/shared/controllers/account_info/account_info_controller.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final accountController = GetIt.instance.get<AccountInfoController>();
    final currentUser = accountController.getUser();
    
    if (currentUser == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person_off,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'Usuário não encontrado',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Faça login para ver seu perfil',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return UserProfilePage(
      userId: currentUser.id,
      showBackButton: false,
    );
  }
}
