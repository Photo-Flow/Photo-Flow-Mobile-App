import 'package:flutter/material.dart';
import 'package:photo_flow_mobile_app/app/app_dependencies.dart';
import 'package:photo_flow_mobile_app/app/app_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDependencies().setupDependencies();
  runApp(const AppWidget());
}
