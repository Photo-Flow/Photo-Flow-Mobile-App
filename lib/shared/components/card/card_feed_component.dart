import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_flow_mobile_app/shared/utils/colors/photo_flow_colors.dart';

class CardFeedComponent extends StatefulWidget {
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
  State<CardFeedComponent> createState() => _CardFeedComponentState();
}

class _CardFeedComponentState extends State<CardFeedComponent> {
  bool _isDownloading = false;  Future<void> _downloadImage() async {
    try {
      setState(() {
        _isDownloading = true;
      });

      // Copiar o URL da imagem para o clipboard
      await Clipboard.setData(ClipboardData(text: widget.feedImageUrl));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.download_done, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Link da imagem copiado! Cole em seu navegador para baixar.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Erro ao preparar download: ${e.toString()}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

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
                  children: [                    CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(widget.profileImageUrl),
                      backgroundColor: PhotoFlowColors.photoFlowTextSecondary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: PhotoFlowColors.photoFlowTextSecondary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
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
                  ),                  onPressed: _isDownloading ? null : _downloadImage,
                  child: _isDownloading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              PhotoFlowColors.photoFlowTextPrimary,
                            ),
                          ),
                        )
                      : const Text(
                          "Download",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16.0),
              bottomRight: Radius.circular(16.0),
            ),            child: Image.network(
              widget.feedImageUrl,
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
