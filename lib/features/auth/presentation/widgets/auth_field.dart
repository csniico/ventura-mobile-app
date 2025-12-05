import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    required this.hintText,
    required this.onSaved,
    this.inputType,
    this.onChanged,
    this.obscureText = false,
    this.suffixIcon,
    this.title,
  });

  final String hintText;
  final String? title;
  final void Function(String)? onChanged;
  final void Function(String?) onSaved;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? inputType;

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
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
          ),
          obscureText: obscureText,
          obscuringCharacter: '*',
          keyboardType: inputType,
          onChanged: onChanged,
          onSaved: onSaved,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$hintText is required!';
            }
            if (inputType == TextInputType.emailAddress &&
                !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            if (inputType == TextInputType.visiblePassword &&
                value.length < 8) {
              return 'Password must be at least 8 characters long';
            }
            return null;
          },
        ),
      ],
    );
  }
}
