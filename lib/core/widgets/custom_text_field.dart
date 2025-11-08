import 'package:flutter/material.dart';

class AppCustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final bool obscureText;
  final int maxLines;
  final TextInputAction? inputAction;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  /// 👇 الإضافة الجديدة:
  final void Function(String)? onSubmitted;

  const AppCustomTextField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.obscureText = false,
    this.maxLines = 1,
    this.inputAction,
    this.keyboardType,
    this.validator,
    this.onSubmitted, // 👈 الإضافة الجديدة
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      maxLines: maxLines,
      textInputAction: inputAction,
      keyboardType: keyboardType,
      validator: validator,
      onFieldSubmitted: onSubmitted, // 👈 استخدمها هنا
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
    );
  }
}
