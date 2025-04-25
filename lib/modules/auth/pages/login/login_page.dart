import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:photo_flow_mobile_app/modules/auth/pages/login/cubit/login_cubit.dart';
import 'package:photo_flow_mobile_app/modules/auth/pages/register/register_page.dart';
import 'package:photo_flow_mobile_app/modules/home/pages/home_page.dart';
import 'package:photo_flow_mobile_app/modules/shared/components/button/button_component.dart';
import 'package:photo_flow_mobile_app/modules/shared/components/text_form_field/text_form_field_component.dart';
import 'package:photo_flow_mobile_app/modules/shared/validators/validators.dart';

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

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocListener(
        bloc: cubit,
        listener: (context, state) {
          switch (state) {
            case LoginLoadingState():
              setState(() => isLoading = true);

            case LoginSuccessState():
              setState(() => isLoading = false);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );

            case LoginErrorState():
              setState(() => isLoading = false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Erro ao realizar login!")),
              );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormFieldComponent(
                      label: "Email:",
                      prefixIcon: Icons.email,
                      controller: emailController,
                      validator: (text) => Validadors.emailValidator(text),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20.0),
                    TextFormFieldComponent(
                      label: "Senha:",
                      prefixIcon: Icons.lock,
                      controller: passwordController,
                      obscureText: true,
                      validator: (text) => Validadors.passwordValidator(text),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 40.0),
                    ButtonComponent(
                      title: "Entrar",
                      isLoading: isLoading,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          cubit.login(
                            emailController.text,
                            passwordController.text,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20.0),
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
    );
  }
}
