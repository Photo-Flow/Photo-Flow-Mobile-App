import 'package:flutter/material.dart';
import 'package:photo_flow_mobile_app/shared/components/loading/loading_component.dart';
import 'package:photo_flow_mobile_app/shared/utils/colors/photo_flow_colors.dart';

class ButtonComponent extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isDisabled;

  const ButtonComponent({
    super.key,
    required this.title,
    this.onTap,
    this.isLoading = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (isLoading || isDisabled) ? null : onTap,
      child: Container(
        height: 48.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color:
              (isLoading || isDisabled)
                  ? Colors.grey
                  : PhotoFlowColors.photoFlowButton,
        ),
        child:
            isLoading
                ? const LoadingComponent()
                : Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: PhotoFlowColors.photoFlowTextPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.0,
                    ),
                  ),
                ),
      ),
    );
  }
}
