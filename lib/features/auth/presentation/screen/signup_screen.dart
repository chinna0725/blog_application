import 'package:blog_application/core/commom/widgets/loader.dart';
import 'package:blog_application/core/theme/app_pallate.dart';
import 'package:blog_application/core/utils/show_snackbar.dart';
import 'package:blog_application/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_application/features/auth/presentation/screen/signin_screen.dart';
import 'package:blog_application/features/auth/presentation/widgets/auth_button.dart';
import 'package:blog_application/features/auth/presentation/widgets/auth_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatefulWidget {
  static route() => {
        MaterialPageRoute(
          builder: (context) => const SignupScreen(),
        )
      };
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackbar(context, state.msg);
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Loader();
            }

            return Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  AuthField(
                    hintText: "Name",
                    controller: nameController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AuthField(
                    hintText: "Email",
                    controller: emailController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AuthField(
                    hintText: "Password",
                    controller: passwordController,
                    isObscureText: true,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  AuthButton(
                    buttonText: "Sign Up",
                    onTap: () {
                      if (formkey.currentState!.validate()) {
                        context.read<AuthBloc>().add(AuthSignup(
                            name: nameController.text.trim(),
                            email: emailController.text.trim(),
                            password: passwordController.text.trim()));
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SignInScreen(),
                      ));
                    },
                    child: RichText(
                      text: TextSpan(
                          style: Theme.of(context).textTheme.titleMedium,
                          text: "Already have an account? ",
                          children: [
                            TextSpan(
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        color: AppPallete.gradient2,
                                        fontWeight: FontWeight.bold),
                                text: "Sign In")
                          ]),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
