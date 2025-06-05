import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:photo_flow_mobile_app/shared/controllers/account_info/account_info_controller.dart';
import 'package:photo_flow_mobile_app/shared/utils/colors/photo_flow_colors.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final accountInfoController = GetIt.instance.get<AccountInfoController>();

  @override
  Widget build(BuildContext context) {
    final user = accountInfoController.getUser();

    return Scaffold(
      backgroundColor: PhotoFlowColors.photoFlowBackground,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 24),
          Image.asset('assets/Logo.png'),
          const SizedBox(height: 24),
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/example_avatar.jpg'), // imagem fixa
          ),
          const SizedBox(height: 12),
          Text(
            "@${user?.email.split('@').first ?? 'email'}",
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
            ),
            child: const Text("Editar Perfil"),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Suas fotos",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: 6, // imagens fixas de exemplo
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.grey.shade800,
                  child: Image.asset(
                    'assets/foto_exemplo.jpg', // imagens locais por enquanto
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
