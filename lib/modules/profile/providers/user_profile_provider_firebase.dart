import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:photo_flow_mobile_app/modules/profile/providers/user_profile_provider.dart';
import 'package:photo_flow_mobile_app/shared/models/user_profile_model.dart';
import 'package:photo_flow_mobile_app/shared/models/post_model.dart';

class UserProfileProviderFirebase implements UserProfileProvider {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  UserProfileProviderFirebase({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance;

  @override
  Future<UserProfileModel> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      
      if (!doc.exists) {
        // Se o perfil não existe, criar um básico
        final user = _auth.currentUser;
        final profile = UserProfileModel(
          id: userId,
          email: user?.email ?? '',
          createdAt: DateTime.now(),
        );
        
        await _firestore.collection('users').doc(userId).set(profile.toMap());
        return profile;
      }
      
      return UserProfileModel.fromMap(doc.data()!);
    } catch (e) {
      throw Exception('Erro ao buscar perfil do usuário: $e');
    }
  }
  @override
  Future<List<PostModel>> getUserPosts(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('photos')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        // Mapear os campos específicos do seu Firestore para o modelo padrão
        final mappedData = {
          'id': data['photoId'] ?? doc.id,
          'userId': data['userId'],
          'imageUrl': data['url'],
          'caption': data['caption'],
          'tags': data['tags'] ?? [],
          'likesCount': data['likesCount'] ?? 0,
          'commentsCount': data['commentsCount'] ?? 0,
          'createdAt': data['createdAt'],
          'isLiked': data['isLiked'] ?? false,
        };
        
        return PostModel.fromMap(mappedData);
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar posts do usuário: $e');
    }
  }

  @override
  Future<void> updateProfile({
    required String userId,
    String? displayName,
    String? bio,
    String? profileImageUrl,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      
      if (displayName != null) updateData['displayName'] = displayName;
      if (bio != null) updateData['bio'] = bio;
      if (profileImageUrl != null) updateData['profileImageUrl'] = profileImageUrl;
      
      await _firestore.collection('users').doc(userId).update(updateData);
    } catch (e) {
      throw Exception('Erro ao atualizar perfil: $e');
    }
  }

  @override
  Future<void> followUser(String currentUserId, String targetUserId) async {
    try {
      final batch = _firestore.batch();
      
      // Adicionar seguindo
      batch.set(
        _firestore.collection('users').doc(currentUserId).collection('following').doc(targetUserId),
        {'followedAt': FieldValue.serverTimestamp()},
      );
      
      // Adicionar seguidor
      batch.set(
        _firestore.collection('users').doc(targetUserId).collection('followers').doc(currentUserId),
        {'followedAt': FieldValue.serverTimestamp()},
      );
      
      await batch.commit();
    } catch (e) {
      throw Exception('Erro ao seguir usuário: $e');
    }
  }

  @override
  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    try {
      final batch = _firestore.batch();
      
      // Remover seguindo
      batch.delete(
        _firestore.collection('users').doc(currentUserId).collection('following').doc(targetUserId),
      );
      
      // Remover seguidor
      batch.delete(
        _firestore.collection('users').doc(targetUserId).collection('followers').doc(currentUserId),
      );
      
      await batch.commit();
    } catch (e) {
      throw Exception('Erro ao deixar de seguir usuário: $e');
    }
  }

  @override
  Future<bool> isFollowing(String currentUserId, String targetUserId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('following')
          .doc(targetUserId)
          .get();
      
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}
