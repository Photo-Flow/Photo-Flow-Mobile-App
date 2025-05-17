import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../providers/photo_upload_provider.dart';
import 'package:photo_flow_mobile_app/shared/controllers/account_info/account_info_controller.dart';
import 'photo_upload_state.dart';

class PhotoUploadCubit extends Cubit<PhotoUploadState> {
  final PhotoUploadProvider photoUploadProvider;
  final AccountInfoController accountInfoController;

  PhotoUploadCubit({
    required this.photoUploadProvider,
    required this.accountInfoController,
  }) : super(const PhotoUploadState());

  Future<void> selectPhoto() async {
    try {
      emit(state.copyWith(status: PhotoUploadStatus.loading));
      final String path = await photoUploadProvider.selectPhoto();
      emit(state.copyWith(
        status: PhotoUploadStatus.success,
        selectedPhotoPath: path,
      ));
    } catch (e) {
      if (e.toString().contains('No image selected')) {
        // Não exibir erro quando o usuário cancela a seleção
        emit(state.copyWith(
          status: PhotoUploadStatus.initial,
        ));
      } else {
        emit(state.copyWith(
          status: PhotoUploadStatus.failure,
          errorMessage: e.toString(),
        ));
      }
    }
  }

  Future<void> uploadPhoto() async {
    if (state.selectedPhotoPath == null) {
      emit(state.copyWith(
        status: PhotoUploadStatus.failure,
        errorMessage: 'Nenhuma foto selecionada',
      ));
      return;
    }

    try {
      emit(state.copyWith(status: PhotoUploadStatus.loading));
      
      // Obter o usuário atual usando o AccountInfoController
      final currentUser = accountInfoController.getUser();
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }
      
      String imagePath = state.selectedPhotoPath!;
      
      // Aplicar redução de ruído se habilitado
      if (state.denoiseEnabled) {
        imagePath = await _denoiseImage(imagePath);
      }
      
      // Usar o ID do usuário atual para o upload
      await photoUploadProvider.uploadPhoto(imagePath, currentUser.id);
      
      emit(state.copyWith(
        status: PhotoUploadStatus.success,
        selectedPhotoPath: null // Limpar a foto após upload bem-sucedido
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PhotoUploadStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
  
  // Método para processar a imagem com a API de denoise
  Future<String> _denoiseImage(String imagePath) async {
    try {
      final url = Uri.parse('https://denoise-image-7q2kvbjouq-uc.a.run.app');
      
      var request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('img', imagePath));
      
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        final decodedResponse = json.decode(responseData);
        final base64Image = decodedResponse['denoised_image'];
        
        // Converter o base64 para um arquivo
        final bytes = base64Decode(base64Image);
        final tempDir = Directory.systemTemp;
        final tempFile = File('${tempDir.path}/denoised_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await tempFile.writeAsBytes(bytes);
        
        return tempFile.path;
      } else {
        throw Exception('Falha ao processar a imagem: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao reduzir ruído da imagem: $e');
    }
  }
  
  // Alternar estado de denoise
  void toggleDenoiseEnabled() {
    emit(state.copyWith(denoiseEnabled: !state.denoiseEnabled));
  }
  
  // Verificar se o usuário está logado usando o AccountInfoController
  bool isUserLoggedIn() {
    return accountInfoController.getUser() != null;
  }
}
