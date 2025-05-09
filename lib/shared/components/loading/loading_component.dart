import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingComponent extends StatelessWidget {
  final Color? color;

  const LoadingComponent({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      color: color ?? Colors.black,
      size: 16.0,
    );
  }
}
