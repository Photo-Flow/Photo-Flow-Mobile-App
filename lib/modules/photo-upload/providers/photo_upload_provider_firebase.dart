import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'photo_upload_provider.dart';

class PhotoUploadProviderFirebase implements PhotoUploadProvider {
  final FirebaseStorage _storage;
  final FirebaseFirestore _firestore;
  final ImagePicker _picker;

  PhotoUploadProviderFirebase({
    FirebaseStorage? storage,
    FirebaseFirestore? firestore,
    ImagePicker? picker,
  })  : _storage = storage ?? FirebaseStorage.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _picker = picker ?? ImagePicker();

  @override
  Future<void> uploadPhoto(String filePath, String userId) async {
    try {
      
      // Gerar um ID único para a foto
      final String photoId = DateTime.now().millisecondsSinceEpoch.toString();

      // Referência para o caminho do arquivo no Storage
      final ref = _storage.ref().child('photos/$userId/$photoId');

      // Preparar metadados para o upload
      final SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'userId': userId,
          'uploadDate': DateTime.now().toIso8601String(),
        },
      );

      final file = File(filePath);
      if (!file.existsSync()) {
        throw Exception('File does not exist at path: $filePath');
      }
      await ref.putFile(file, metadata);


      // Obter a URL de download pública
      final String downloadUrl = await ref.getDownloadURL();

      // Criar objeto com dados da foto
      final photoData = {
        'photoId': photoId,
        'url': downloadUrl,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Salvar referência no Firestore na coleção do usuário
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('photos')
          .doc(photoId)
          .set(photoData);

      // Também salvar na coleção global de fotos para facilitar consultas
      await _firestore.collection('photos').doc(photoId).set(photoData);
    } catch (e) {
      throw Exception('Failed to upload photo: $e');
    }
  }

  @override
  Future<String> selectPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // Reduzir um pouco a qualidade para otimizar o upload
      );
      if (image == null) {
        throw Exception('No image selected');
      }
      return image.path;
    } catch (e) {
      throw Exception('Failed to select photo: $e');
    }
  }
}
