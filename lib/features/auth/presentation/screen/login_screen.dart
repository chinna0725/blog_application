import 'package:flutter/material.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: ClipPath(
        clipper: MyClipper(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: size.height * 0.9,
            decoration: const BoxDecoration(
              // borderRadius: BorderRadius.all(
              //   Radius.circular(10),
              // ),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.8);
    path.quadraticBezierTo(0, size.height * 0.82, 50, size.height * 0.84);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
