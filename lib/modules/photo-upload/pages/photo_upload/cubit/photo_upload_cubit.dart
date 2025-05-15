import 'package:flutter_bloc/flutter_bloc.dart';
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
      emit(state.copyWith(
        status: PhotoUploadStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> uploadPhoto() async {
    if (state.selectedPhotoPath == null) {
      emit(state.copyWith(
        status: PhotoUploadStatus.failure,
        errorMessage: 'No photo selected',
      ));
      return;
    }

    try {
      emit(state.copyWith(status: PhotoUploadStatus.loading));
      
      // Obter o usuário atual usando o AccountInfoController
      final currentUser = accountInfoController.getUser();
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }
      
      // Usar o ID do usuário atual para o upload
      await photoUploadProvider.uploadPhoto(state.selectedPhotoPath!, currentUser.id);
      
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
  
  // Verificar se o usuário está logado usando o AccountInfoController
  bool isUserLoggedIn() {
    return accountInfoController.getUser() != null;
  }
}
