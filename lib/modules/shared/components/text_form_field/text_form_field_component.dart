import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldComponent extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final bool obscureText;
  final IconData? suffixIcon;
  final VoidCallback? onTapSuffixIcon;
  final String? Function(String? text)? validator;
  final void Function(String? text)? onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final int maxLines;
  final int minLines;

  const TextFormFieldComponent({
    super.key,
    required this.label,
    required this.controller,
    this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.onTapSuffixIcon,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.inputFormatters,
    this.enabled,
    this.maxLines = 15,
    this.minLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        inputFormatters: inputFormatters ?? [],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        onChanged: onChanged,
        obscureText: obscureText,
        cursorColor: Colors.black,
        maxLines: obscureText ? 1 : maxLines,
        minLines: obscureText ? null : minLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(prefixIcon),
          suffixIcon: IconButton(
            icon: Icon(suffixIcon),
            onPressed: onTapSuffixIcon,
          ),
        ),
      ),
    );
  }
}
