abstract class PhotoUploadProvider {
  Future<void> uploadPhoto(String filePath);
  Future<String> selectPhoto();
}
