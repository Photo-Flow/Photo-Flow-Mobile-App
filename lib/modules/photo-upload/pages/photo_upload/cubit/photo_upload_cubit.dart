import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../providers/photo_upload_provider.dart';
import 'photo_upload_state.dart';

class PhotoUploadCubit extends Cubit<PhotoUploadState> {
  final PhotoUploadProvider photoUploadProvider;
  final FirebaseAuth _auth;

  PhotoUploadCubit({
    required this.photoUploadProvider, 
    FirebaseAuth? firebaseAuth,
  }) : _auth = firebaseAuth ?? FirebaseAuth.instance, 
       super(const PhotoUploadState());

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
      
      // Obter o usuário atual autenticado
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }
      
      // Usar o ID do usuário atual para o upload
      await photoUploadProvider.uploadPhoto(state.selectedPhotoPath!, currentUser.uid);
      
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
  
  // Método auxiliar para verificar se o usuário está logado
  bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }
  
  // Método para obter o ID do usuário atual
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }
}
