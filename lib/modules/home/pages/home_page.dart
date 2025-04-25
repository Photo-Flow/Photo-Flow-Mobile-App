import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:photo_flow_mobile_app/modules/home/pages/cubit/home_cubit.dart';
import 'package:photo_flow_mobile_app/modules/shared/controllers/account_info/account_info_controller.dart';

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
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text(user?.id.toString() ?? ""), Text(user?.email ?? "")],
        ),
      ),
    );
  }
}
