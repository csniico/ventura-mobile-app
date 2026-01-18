import 'package:flutter/material.dart';

class TextInputComponent extends StatelessWidget {
  const TextInputComponent({
    super.key,
    required this.title,
    required this.onSaved,
    this.controller,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.isRequired = false,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.enabled = true,
    this.hintText,
  });

  final String? hintText;
  final String title;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String?) onSaved;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool isRequired;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            title,
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: hintText,
          ),
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          onChanged: onChanged,
          onSaved: onSaved,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          enabled: enabled,
          validator:
              validator ??
              (isRequired
                  ? (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '$title is required';
                      }
                      return null;
                    }
                  : null),
        ),
      ],
    );
  }
}
