import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'photo_upload_provider.dart';

class PhotoUploadProviderFirebase implements PhotoUploadProvider {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  @override
  Future<void> uploadPhoto(String filePath) async {
    try {
      final ref = _storage.ref().child('photos/${DateTime.now().millisecondsSinceEpoch}');
      await ref.putFile(File(filePath));
    } catch (e) {
      throw Exception('Failed to upload photo: $e');
    }
  }

  @override
  Future<String> selectPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        throw Exception('No image selected');
      }
      return image.path;
    } catch (e) {
      throw Exception('Failed to select photo: $e');
    }
  }
}
