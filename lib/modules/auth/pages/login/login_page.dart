import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:photo_flow_mobile_app/modules/auth/pages/login/cubit/login_cubit.dart';
import 'package:photo_flow_mobile_app/modules/auth/pages/register/register_page.dart';
import 'package:photo_flow_mobile_app/modules/home/pages/navigation_bar/navigation_bar_page.dart';
import 'package:photo_flow_mobile_app/shared/components/button/button_component.dart';
import 'package:photo_flow_mobile_app/shared/components/text_form_field/text_form_field_component.dart';
import 'package:photo_flow_mobile_app/shared/utils/colors/photo_flow_colors.dart';
import 'package:photo_flow_mobile_app/shared/utils/validators/validators.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final cubit = GetIt.instance.get<LoginCubit>();

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhotoFlowColors.photoFlowBackground,
      body: BlocListener<LoginCubit, LoginState>(
        bloc: cubit,
        listener: (context, state) {
          switch (state) {
            case LoginInitialState():
              break;
            case LoginLoadingState():
              break;
            case LoginSuccessState():
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const NavigationBarPage()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Bem vindo! ${state.user.email}")),
              );
            case LoginErrorState():
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Erro ao realizar login!")),
              );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 120),
            Image.asset('assets/Logo.png'),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormFieldComponent(
                            label: "Email:",
                            prefixIcon: Icons.email,
                            controller: emailController,
                            validator:
                                (text) => Validadors.emailValidator(text),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 10.0),
                          TextFormFieldComponent(
                            label: "Senha:",
                            prefixIcon: Icons.lock,
                            controller: passwordController,
                            obscureText: true,
                            validator:
                                (text) => Validadors.passwordValidator(text),
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 40.0),
                          BlocBuilder(
                            bloc: cubit,
                            builder: (context, state) {
                              return ButtonComponent(
                                title: "Entrar",
                                isLoading: state is LoginLoadingState,
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.login(
                                      emailController.text,
                                      passwordController.text,
                                    );
                                  }
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 10.0),
                          ButtonComponent(
                            title: "Criar conta",
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterPage(),
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
