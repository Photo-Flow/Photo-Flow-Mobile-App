import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:photo_flow_mobile_app/modules/home/pages/home/cubit/home_cubit.dart';
import 'package:photo_flow_mobile_app/shared/controllers/account_info/account_info_controller.dart';
import 'package:photo_flow_mobile_app/shared/utils/colors/photo_flow_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cubit = GetIt.instance.get<HomeCubit>();
  final accountInfoController = GetIt.instance.get<AccountInfoController>();

  @override
  void initState() {
    cubit.fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = accountInfoController.getUser();

    return Scaffold(
      backgroundColor: PhotoFlowColors.photoFlowBackground,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 24),
          Image.asset('assets/Logo.png'),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    user?.email ?? "",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
