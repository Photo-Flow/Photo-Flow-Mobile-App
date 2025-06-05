import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:photo_flow_mobile_app/shared/components/button/button_component.dart';
import 'package:photo_flow_mobile_app/shared/components/loading/loading_component.dart';
import 'package:photo_flow_mobile_app/shared/utils/colors/photo_flow_colors.dart';
import 'cubit/photo_upload_cubit.dart';
import 'cubit/photo_upload_state.dart';

class PhotoUploadPage extends StatefulWidget {
  const PhotoUploadPage({super.key});

  @override
  State<PhotoUploadPage> createState() => _PhotoUploadPageState();
}

class _PhotoUploadPageState extends State<PhotoUploadPage> {
  final cubit = GetIt.instance.get<PhotoUploadCubit>();

  @override
  void initState() {
    super.initState();
    // Verifica se o usuário está autenticado quando a página é carregada
    if (!cubit.isUserLoggedIn()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Mostra aviso se não estiver autenticado
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Você precisa estar logado para publicar fotos'),
            backgroundColor: Colors.red,
          ),
        );
        // Aqui você pode adicionar lógica para redirecionar para a tela de login
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Photo'),
        backgroundColor: PhotoFlowColors.photoFlowButton,
      ),
      backgroundColor: PhotoFlowColors.photoFlowBackground,
      body: SafeArea(
        child: BlocConsumer<PhotoUploadCubit, PhotoUploadState>(
          bloc: cubit,
          listener: (context, state) {
            // Exibir SnackBar de sucesso quando o upload for bem-sucedido
            if (state.status == PhotoUploadStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Foto publicada com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
            }

            // Exibir SnackBar de erro quando ocorrer uma falha
            if (state.status == PhotoUploadStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Ocorreu um erro'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Card(
                              color: PhotoFlowColors.photoFlowInputBackground,
                              // Usando o cardTheme definido no tema
                              child: InkWell(
                                onTap: () {
                                  cubit.selectPhoto();
                                },
                                borderRadius: BorderRadius.circular(24.0),
                                child:
                                    state.selectedPhotoPath != null
                                        ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            24.0,
                                          ),
                                          child: Image.file(
                                            File(state.selectedPhotoPath!),
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                        : const Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.camera_alt_outlined,
                                                size: 48,
                                                color:
                                                    PhotoFlowColors
                                                        .photoFlowButton,
                                              ),
                                              SizedBox(height: 16),
                                              Text(
                                                'Toque para selecionar',
                                                style: TextStyle(
                                                  color:
                                                      PhotoFlowColors
                                                          .photoFlowButton,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Slider para remover ruído apenas quando há uma foto selecionada
                      if (state.selectedPhotoPath != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              const Text(
                                'Remover ruído:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Expanded(
                                child: Switch(
                                  value: state.denoiseEnabled,
                                  onChanged: (value) {
                                    cubit.toggleDenoiseEnabled();
                                  },
                                  activeColor: PhotoFlowColors.photoFlowButton,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),
                      // Usando o ButtonComponent em vez do ElevatedButton
                      ButtonComponent(
                        title:
                            cubit.isUserLoggedIn()
                                ? 'Publicar'
                                : 'Faça login para publicar',
                        onTap: () {
                          cubit.uploadPhoto();
                        },
                        isLoading: state.status == PhotoUploadStatus.loading,
                        isDisabled:
                            !cubit.isUserLoggedIn() ||
                            state.selectedPhotoPath == null,
                      ),
                    ],
                  ),
                ),
                if (state.status == PhotoUploadStatus.loading)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      // Usando o LoadingComponent
                      child: LoadingComponent(
                        color: PhotoFlowColors.photoFlowButton,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
