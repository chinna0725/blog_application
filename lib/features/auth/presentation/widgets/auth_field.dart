import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  const AuthField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.isObscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscureText,
      decoration: InputDecoration(
          hintText: hintText, contentPadding: const EdgeInsets.all(27)),
      validator: (value) {
        if (value!.isEmpty) {
          return hintText;
        }
        return null;
      },
    );
  }
}
