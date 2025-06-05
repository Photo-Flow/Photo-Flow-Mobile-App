class UserProfileModel {
  final String id;
  final String email;
  final String? displayName;
  final String? bio;
  final String? profileImageUrl;
  final int postsCount;
  final int followersCount;
  final int followingCount;
  final bool isVerified;
  final DateTime createdAt;

  const UserProfileModel({
    required this.id,
    required this.email,
    this.displayName,
    this.bio,
    this.profileImageUrl,
    this.postsCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.isVerified = false,
    required this.createdAt,
  });

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'],
      bio: map['bio'],
      profileImageUrl: map['profileImageUrl'],
      postsCount: map['postsCount'] ?? 0,
      followersCount: map['followersCount'] ?? 0,
      followingCount: map['followingCount'] ?? 0,
      isVerified: map['isVerified'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'postsCount': postsCount,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserProfileModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? bio,
    String? profileImageUrl,
    int? postsCount,
    int? followersCount,
    int? followingCount,
    bool? isVerified,
    DateTime? createdAt,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      postsCount: postsCount ?? this.postsCount,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
