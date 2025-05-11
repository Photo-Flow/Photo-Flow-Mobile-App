import 'package:equatable/equatable.dart';

enum PhotoUploadStatus { initial, loading, success, failure }

class PhotoUploadState extends Equatable {
  final PhotoUploadStatus status;
  final String? errorMessage;
  final String? selectedPhotoPath;

  const PhotoUploadState({
    this.status = PhotoUploadStatus.initial,
    this.errorMessage,
    this.selectedPhotoPath,
  });

  PhotoUploadState copyWith({
    PhotoUploadStatus? status,
    String? errorMessage,
    String? selectedPhotoPath,
  }) {
    return PhotoUploadState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedPhotoPath: selectedPhotoPath ?? this.selectedPhotoPath,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, selectedPhotoPath];
}
