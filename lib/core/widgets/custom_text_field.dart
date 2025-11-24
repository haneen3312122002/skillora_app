import 'package:flutter/material.dart';
import 'animation/fade_in.dart';
import 'animation/slide_in.dart';

class AppCustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final bool obscureText;
  final int maxLines;
  final TextInputAction? inputAction;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  // when user submits from keyboard.
  final void Function(String)? onSubmitted;

  // Animate field when it appears
  final bool animate;
  final Duration animationDuration;
  final Duration? delay;
  final Offset slideFrom;

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
    this.onSubmitted,
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 220),
    this.delay,
    this.slideFrom = const Offset(0, 8),
  });

  @override
  Widget build(BuildContext context) {
    Widget field = TextFormField(
      controller: controller,
      obscureText: obscureText,
      maxLines: maxLines,
      textInputAction: inputAction,
      keyboardType: keyboardType,
      validator: validator,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
    );

    if (!animate) return field;

    return FadeIn(
      duration: animationDuration,
      child: SlideIn(
        from: slideFrom,
        duration: animationDuration,
        child: field,
      ),
    );
  }
}
