import 'package:flutter/material.dart';
import 'package:photo_flow_mobile_app/app/app_theme.dart';
import 'package:photo_flow_mobile_app/modules/auth/pages/login/login_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Flow App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const LoginPage(),
    );
  }
}
