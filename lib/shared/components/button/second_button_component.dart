import 'package:flutter/material.dart';

class SecondButtonComponent extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const SecondButtonComponent({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24.0),
      onTap: onTap,
      child: Container(
        height: 48.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          color: Colors.transparent,
          border: Border.all(color: Colors.green[900]!),
          
        ),
        child: Center(
          child: Text(title),
        ),
      ),
    );
  }
}
