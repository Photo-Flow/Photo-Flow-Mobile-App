import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:photo_flow_mobile_app/modules/profile/pages/update/cubit/update_cubit.dart';
import 'package:photo_flow_mobile_app/shared/components/button/button_component.dart';
import 'package:photo_flow_mobile_app/shared/components/text_form_field/text_form_field_component.dart';
import 'package:photo_flow_mobile_app/shared/utils/colors/photo_flow_colors.dart';
import 'package:photo_flow_mobile_app/shared/utils/validators/validators.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => __UpdatePageState();
}

class __UpdatePageState extends State<UpdatePage> {
  final cubit = GetIt.instance.get<UpdateCubit>();
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/Logo.png'),
        centerTitle: true,
        backgroundColor: PhotoFlowColors.photoFlowBackground,
      ),
      backgroundColor: PhotoFlowColors.photoFlowBackground,
      body: BlocListener(
        bloc: cubit,
        listener: (context, state) {
          switch (state) {
            case UpdateLoadingState():
              setState(() => isLoading = true);

            case UpdateSuccessState():
              setState(() => isLoading = false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Conta atualizada com sucesso!")),
              );

            case UpdateErrorState():
              setState(() => isLoading = false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Erro ao atualizar conta!")),
              );
          } // end switch
        }, // end listener
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(
                                Icons.account_circle,
                                size: 100,
                                color: PhotoFlowColors.photoFlowInputBackground,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: PhotoFlowColors.photoFlowBackground,
                                  ),
                                  child: const Icon(
                                    Icons.add_circle,
                                    size: 40,
                                    color: PhotoFlowColors.photoFlowButton,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          TextFormFieldComponent(
                            label: "Email Atual",
                            prefixIcon: Icons.email,
                            controller: emailController,
                            validator:
                                (text) => Validadors.emailValidator(text),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 10.0),
                          TextFormFieldComponent(
                            label: "Senha Atual",
                            prefixIcon: Icons.lock,
                            controller: currentPasswordController,
                            obscureText: true,
                            validator:
                                (text) => Validadors.passwordValidator(text),
                          ),
                          const SizedBox(height: 10.0),
                          TextFormFieldComponent(
                            label: "Nova Senha",
                            prefixIcon: Icons.lock,
                            controller: newPasswordController,
                            obscureText: true,
                            validator:
                                (text) => Validadors.passwordValidator(text),
                          ),
                          const SizedBox(height: 10.0),
                          TextFormFieldComponent(
                            label: "Confirmar Senha",
                            prefixIcon: Icons.lock,
                            controller: confirmPasswordController,
                            obscureText: true,
                            validator:
                                (text) => Validadors.confirmPasswordValidator(
                                  text,
                                  newPasswordController.text,
                                ),
                          ),
                          const SizedBox(height: 40.0),
                          ButtonComponent(
                            title: "Salvar Alterações",
                            isLoading: isLoading,
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                cubit.update(
                                  email: emailController.text,
                                  currentPassword:
                                      currentPasswordController.text,
                                  newPassword: newPasswordController.text,
                                  confirmPassword:
                                      confirmPasswordController.text,
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
          ],
        ),
      ),
    );
  }
}
