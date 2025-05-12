import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:photo_flow_mobile_app/modules/auth/pages/register/cubit/register_cubit.dart';
import 'package:photo_flow_mobile_app/shared/components/button/button_component.dart';
import 'package:photo_flow_mobile_app/shared/components/text_form_field/text_form_field_component.dart';
import 'package:photo_flow_mobile_app/shared/utils/colors/photo_flow_colors.dart';
import 'package:photo_flow_mobile_app/shared/utils/validators/validators.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final cubit = GetIt.instance.get<RegisterCubit>();

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar conta'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: PhotoFlowColors.photoFlowBackground,
      body: BlocListener(
        bloc: cubit,
        listener: (context, state) {
          switch (state) {
            case RegisterLoadingState():
              setState(() => isLoading = true);

            case RegisterSuccessState():
              setState(() => isLoading = false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Conta criada com sucesso!")),
              );
              Navigator.pop(context);

            case RegisterErrorState():
              setState(() => isLoading = false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Erro ao criar conta!")),
              );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    const SizedBox(height: 10.0),
                    TextFormFieldComponent(
                      label: "Senha:",
                      prefixIcon: Icons.lock,
                      controller: passwordController,
                      obscureText: true,
                      validator: (text) => Validadors.passwordValidator(text),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10.0),
                    TextFormFieldComponent(
                      label: "Confirmar Senha:",
                      prefixIcon: Icons.lock,
                      controller: confirmPasswordController,
                      obscureText: true,
                      validator:
                          (text) => Validadors.confirmPasswordValidator(
                            text,
                            passwordController.text,
                          ),
                    ),
                    const SizedBox(height: 40.0),
                    ButtonComponent(
                      title: "Criar conta",
                      isLoading: isLoading,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          cubit.register(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                        }
                      },
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
