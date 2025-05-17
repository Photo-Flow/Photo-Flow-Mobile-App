import 'package:equatable/equatable.dart';

enum PhotoUploadStatus { initial, loading, success, failure }

class PhotoUploadState extends Equatable {
  final PhotoUploadStatus status;
  final String? errorMessage;
  final String? selectedPhotoPath;
  final bool denoiseEnabled;

  const PhotoUploadState({
    this.status = PhotoUploadStatus.initial,
    this.errorMessage,
    this.selectedPhotoPath,
    this.denoiseEnabled = false,
  });

  PhotoUploadState copyWith({
    PhotoUploadStatus? status,
    String? errorMessage,
    String? selectedPhotoPath,
    bool? denoiseEnabled,
  }) {
    return PhotoUploadState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedPhotoPath: selectedPhotoPath ?? this.selectedPhotoPath,
      denoiseEnabled: denoiseEnabled ?? this.denoiseEnabled,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, selectedPhotoPath, denoiseEnabled];
}
