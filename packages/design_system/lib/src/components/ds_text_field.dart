import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tokens/ds_radius.dart';

/// A labelled text field.
///
/// The label is a real [InputDecoration.labelText] rather than a hint, because
/// a hint disappears the moment the user types and leaves a screen reader with
/// an unnamed field.
class DSTextField extends StatelessWidget {
  const DSTextField({
    required this.label,
    required this.controller,
    this.hint,
    this.errorText,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.textInputAction,
    this.maxLines = 1,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? errorText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      textInputAction: textInputAction,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        border: const OutlineInputBorder(borderRadius: DSRadius.allSm),
      ),
    );
  }
}
