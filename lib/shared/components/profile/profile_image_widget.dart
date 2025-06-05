import 'package:flutter/material.dart';
import 'package:photo_flow_mobile_app/shared/utils/colors/photo_flow_colors.dart';

class ProfileImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final bool showBorder;
  final VoidCallback? onTap;

  const ProfileImageWidget({
    super.key,
    this.imageUrl,
    this.size = 80,
    this.showBorder = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: showBorder
              ? Border.all(
                  color: PhotoFlowColors.photoFlowButton,
                  width: 2,
                )
              : null,
        ),
        child: ClipOval(
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
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
                )
              : _buildDefaultAvatar(),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: PhotoFlowColors.photoFlowInputBackground,
      child: Icon(
        Icons.person,
        size: size * 0.6,
        color: PhotoFlowColors.photoFlowTextSecondary,
      ),
    );
  }
}
