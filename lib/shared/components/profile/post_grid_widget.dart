import 'package:flutter/material.dart';
import 'package:photo_flow_mobile_app/shared/models/post_model.dart';
import 'package:photo_flow_mobile_app/shared/utils/colors/photo_flow_colors.dart';

class PostGridWidget extends StatelessWidget {
  final List<PostModel> posts;
  final Function(PostModel) onPostTap;

  const PostGridWidget({
    super.key,
    required this.posts,
    required this.onPostTap,
  });

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 64,
              color: PhotoFlowColors.photoFlowTextSecondary,
            ),
            SizedBox(height: 16),
            Text(
              'Nenhuma foto ainda',
              style: TextStyle(
                fontSize: 18,
                color: PhotoFlowColors.photoFlowTextSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Compartilhe suas primeiras fotos!',
              style: TextStyle(
                fontSize: 14,
                color: PhotoFlowColors.photoFlowTextSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return GestureDetector(
          onTap: () => onPostTap(post),
          child: Container(
            decoration: BoxDecoration(
              color: PhotoFlowColors.photoFlowInputBackground,
              borderRadius: BorderRadius.circular(4),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    post.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: PhotoFlowColors.photoFlowInputBackground,
                      child: const Icon(
                        Icons.broken_image,
                        color: PhotoFlowColors.photoFlowTextSecondary,
                      ),
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: PhotoFlowColors.photoFlowInputBackground,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              PhotoFlowColors.photoFlowButton,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // Overlay com estatísticas se tiver múltiplas imagens
                  if (post.commentsCount > 0 || post.likesCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (post.likesCount > 0) ...[
                              const Icon(
                                Icons.favorite,
                                size: 12,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                post.likesCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
