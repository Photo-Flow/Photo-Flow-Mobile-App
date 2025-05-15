import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_flow_mobile_app/shared/utils/colors/photo_flow_colors.dart';

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
    return TextFormField(
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
      style: const TextStyle(color: PhotoFlowColors.photoFlowTextSecondary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: PhotoFlowColors.photoFlowTextSecondary,
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: PhotoFlowColors.photoFlowTextSecondary,
        ),
        suffixIcon: IconButton(
          icon: Icon(suffixIcon, color: PhotoFlowColors.photoFlowTextSecondary),
          onPressed: onTapSuffixIcon,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        fillColor: PhotoFlowColors.photoFlowInputBackground,
        filled: true,
      ),
    );
  }
}
