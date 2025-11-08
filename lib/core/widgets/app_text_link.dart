import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

/// A reusable text-only button (link-style) with optional icons.
/// - Localizes the label using EasyLocalization.
/// - Underlined by default to look like a link.
/// - Center-aligned by default.
///
/// Usage:
/// AppTextLink(
///   textKey: 'create_account',
///   onPressed: () { /* navigate */ },
/// )
class AppTextLink extends StatelessWidget {
  final String textKey; // localization key
  final VoidCallback onPressed;
  final TextStyle? style; // optional custom style
  final bool underline; // underline text?
  final IconData? leadingIcon; // optional left icon
  final IconData? trailingIcon; // optional right icon
  final double gap; // space between icon and text
  final EdgeInsetsGeometry padding; // clickable padding
  final Alignment alignment; // alignment in its parent

  const AppTextLink({
    super.key,
    required this.textKey,
    required this.onPressed,
    this.style,
    this.underline = true,
    this.leadingIcon = null,
    this.trailingIcon = null,
    this.gap = 6.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = style ?? Theme.of(context).textTheme.bodySmall;
    final linkStyle = (baseStyle ?? const TextStyle())
        .copyWith(decoration: underline ? TextDecoration.underline : null);

    final label = Text(textKey.tr(), style: linkStyle);

    Widget content;
    if (leadingIcon != null || trailingIcon != null) {
      final children = <Widget>[];
      if (leadingIcon != null) {
        children.add(Icon(leadingIcon, size: (baseStyle?.fontSize ?? 14) + 2));
        children.add(SizedBox(width: gap));
      }
      children.add(label);
      if (trailingIcon != null) {
        children.add(SizedBox(width: gap));
        children.add(Icon(trailingIcon, size: (baseStyle?.fontSize ?? 14) + 2));
      }
      content = Row(mainAxisSize: MainAxisSize.min, children: children);
    } else {
      content = label;
    }

    return Align(
      alignment: alignment,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(padding: padding),
        child: content,
      ),
    );
  }
}
