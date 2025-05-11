import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../providers/photo_upload_provider.dart';
import 'photo_upload_state.dart';

class PhotoUploadCubit extends Cubit<PhotoUploadState> {
  final PhotoUploadProvider photoUploadProvider;

  PhotoUploadCubit({required this.photoUploadProvider}) : super(const PhotoUploadState());

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
      await photoUploadProvider.uploadPhoto(state.selectedPhotoPath!);
      emit(state.copyWith(status: PhotoUploadStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: PhotoUploadStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
