import 'package:flutter/material.dart';

class SalesTextInputField extends StatelessWidget {
  const SalesTextInputField({
    super.key,
    this.initialValue,
    this.controller,
    required this.hintText,
    required this.onSaved,
    this.inputType,
    this.onChanged,
    this.min = 1,
    this.suffixIcon,
    this.title,
    this.shouldValidate = false,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String hintText;
  final String? title;
  final void Function(String)? onChanged;
  final void Function(String?) onSaved;
  final Widget? suffixIcon;
  final int min;
  final TextInputType? inputType;
  final bool? shouldValidate;

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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          minLines: min,
          maxLines: null,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
          ),
          keyboardType: inputType,
          onChanged: onChanged,
          onSaved: onSaved,
          validator: shouldValidate == true
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return '$hintText is required!';
                  }
                  if (inputType == TextInputType.emailAddress &&
                      !RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }
}
