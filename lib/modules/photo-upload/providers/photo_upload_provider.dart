abstract class PhotoUploadProvider {
  Future<void> uploadPhoto(String filePath, String userId);
  Future<String> selectPhoto();
}
