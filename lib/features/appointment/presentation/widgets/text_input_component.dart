import 'package:flutter/material.dart';

class TextInputComponent extends StatelessWidget {
  const TextInputComponent({
    super.key,
    required this.hintText,
    required this.onSaved,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.title,
    this.isRequired = false,
  });

  final String hintText;
  final String? title;
  final void Function(String)? onChanged;
  final void Function(String?) onSaved;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            title ?? '',
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(hintText: hintText),
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          onChanged: onChanged,
          onSaved: onSaved,
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return '$title is required!';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }
}
