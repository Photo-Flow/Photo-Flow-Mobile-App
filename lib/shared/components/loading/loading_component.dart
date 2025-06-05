import 'package:flutter/material.dart';
import 'package:photo_flow_mobile_app/shared/utils/colors/photo_flow_colors.dart';

class LoadingComponent extends StatelessWidget {
  final Color? color;

  const LoadingComponent({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
        color ?? PhotoFlowColors.photoFlowButton,
      ),
      strokeWidth: 2,
    );
  }
}
