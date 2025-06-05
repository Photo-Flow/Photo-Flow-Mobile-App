import 'package:flutter/material.dart';
import 'package:photo_flow_mobile_app/shared/utils/colors/photo_flow_colors.dart';

class CardFeedComponent extends StatelessWidget {
  final String userName;
  final String profileImageUrl;
  final String feedImageUrl;

  const CardFeedComponent({
    super.key,
    required this.userName,
    required this.profileImageUrl,
    required this.feedImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: PhotoFlowColors.photoFlowInputBackground,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(profileImageUrl),
                      backgroundColor: PhotoFlowColors.photoFlowTextSecondary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: PhotoFlowColors.photoFlowTextSecondary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // const Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Text(
                //       "Download",
                //       style: TextStyle(
                //         backgroundColor: PhotoFlowColors.photoFlowButton,
                //         color: PhotoFlowColors.photoFlowTextPrimary,
                //         fontSize: 14,
                //       ),
                //     ),
                //   ],
                // ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PhotoFlowColors.photoFlowButton,
                    foregroundColor: PhotoFlowColors.photoFlowTextPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // TODO: implementar lógica de download
                  },
                  child: const Text(
                    "Download",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16.0),
              bottomRight: Radius.circular(16.0),
            ),
            child: Image.network(
              feedImageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    height: 300,
                    color: PhotoFlowColors.photoFlowInputBackground,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 50,
                        color: PhotoFlowColors.photoFlowTextSecondary,
                      ),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
