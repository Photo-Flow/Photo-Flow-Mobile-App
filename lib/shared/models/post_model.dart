import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String userId;
  final String imageUrl;
  final String? caption;
  final List<String> tags;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;
  final bool isLiked;

  const PostModel({
    required this.id,
    required this.userId,
    required this.imageUrl,
    this.caption,
    this.tags = const [],
    this.likesCount = 0,
    this.commentsCount = 0,
    required this.createdAt,
    this.isLiked = false,
  });
  factory PostModel.fromMap(Map<String, dynamic> map) {
    // Lidar com diferentes tipos de data (Timestamp do Firestore ou String)
    DateTime createdAtDateTime;
    if (map['createdAt'] is Timestamp) {
      createdAtDateTime = (map['createdAt'] as Timestamp).toDate();
    } else if (map['createdAt'] is String) {
      createdAtDateTime = DateTime.parse(map['createdAt']);
    } else {
      createdAtDateTime = DateTime.now(); // Fallback
    }

    return PostModel(
      id: map['id'] ?? map['photoId'] ?? '', // Suporte para ambos os campos
      userId: map['userId'] ?? '',
      imageUrl: map['imageUrl'] ?? map['url'] ?? '', // Suporte para ambos os campos
      caption: map['caption'],
      tags: List<String>.from(map['tags'] ?? []),
      likesCount: map['likesCount'] ?? 0,
      commentsCount: map['commentsCount'] ?? 0,
      createdAt: createdAtDateTime,
      isLiked: map['isLiked'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'imageUrl': imageUrl,
      'caption': caption,
      'tags': tags,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'createdAt': createdAt.toIso8601String(),
      'isLiked': isLiked,
    };
  }

  PostModel copyWith({
    String? id,
    String? userId,
    String? imageUrl,
    String? caption,
    List<String>? tags,
    int? likesCount,
    int? commentsCount,
    DateTime? createdAt,
    bool? isLiked,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      imageUrl: imageUrl ?? this.imageUrl,
      caption: caption ?? this.caption,
      tags: tags ?? this.tags,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      createdAt: createdAt ?? this.createdAt,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
