import 'package:flutter/material.dart';

class CardComponent extends StatelessWidget {
  final String title;
  final String subtitle;
  final double? width;

  const CardComponent({
    super.key,
    required this.title,
    required this.subtitle,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: SizedBox(
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
