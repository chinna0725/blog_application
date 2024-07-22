import 'package:blog_application/core/theme/app_pallate.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  const AuthButton({super.key, required this.buttonText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [AppPallete.gradient1, AppPallete.gradient2])),
      child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
              fixedSize: Size(size.width - 50, 55),
              shadowColor: AppPallete.transparentColor,
              backgroundColor: AppPallete.transparentColor),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          )),
    );
  }
}
