import 'dart:io';
import 'package:blog_application/core/commom/cubits/app_user/app_user_cubit.dart';
import 'package:blog_application/core/commom/widgets/loader.dart';
import 'package:blog_application/core/theme/app_pallate.dart';
import 'package:blog_application/core/utils/pick_image.dart';
import 'package:blog_application/core/utils/show_snackbar.dart';
import 'package:blog_application/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_application/features/blog/presentation/screens/blog_app.dart';
import 'package:blog_application/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  List<String> selectedChips = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  final formkey = GlobalKey<FormState>();
  File? imageFile;

// picking image------------------------
  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        imageFile = pickedImage;
      });
    }
  }

// upoading blog ----------------------------
  void uploadBlog() {
    if (
        // formkey.currentState!.validate() &&
        imageFile != null && selectedChips.isNotEmpty) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(
            BlogUpload(
              posterId: posterId,
              title: titleController.text.trim(),
              content: contentController.text.trim(),
              imageFile: imageFile!,
              topics: selectedChips,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                uploadBlog();
              },
              icon: const Icon(Icons.done_rounded),
            ),
          ],
        ),
        body: BlocConsumer<BlogBloc, BlogState>(listener: (context, state) {
          if (state is BlogFailure) {
            showSnackbar(context, state.message);
          } else if (state is BlogSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BlogApp(),
              ),
              (route) => false,
            );
          }
        }, builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                key: formkey,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      selectImage();
                    },
                    child: imageFile != null
                        ? SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                imageFile!,
                                fit: BoxFit.cover,
                              ),
                            ))
                        : DottedBorder(
                            color: AppPallete.borderColor,
                            dashPattern: const [10, 4],
                            radius: const Radius.circular(10),
                            borderType: BorderType.RRect,
                            strokeCap: StrokeCap.round,
                            child: Container(
                              height: 150,
                              // decoration: BoxDecoration(
                              color: AppPallete.backgroundColor,

                              width: double.infinity,
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.folder_open,
                                    size: 40,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Select your image",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        "Technology",
                        'Business',
                        'programming',
                        "entertainment",
                      ]
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: GestureDetector(
                                onTap: () {
                                  if (selectedChips.contains(e)) {
                                    selectedChips.remove(e);
                                  } else {
                                    selectedChips.add(e);
                                  }

                                  setState(() {});
                                },
                                child: Chip(
                                  label: Text(e),
                                  color: selectedChips.contains(e)
                                      ? const MaterialStatePropertyAll(
                                          AppPallete.gradient1,
                                        )
                                      : null,
                                  side: selectedChips.contains(e)
                                      ? null
                                      : const BorderSide(
                                          color: AppPallete.borderColor,
                                        ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  //---------------------------
                  BlogEditor(
                    controller: titleController,
                    hintText: 'Blog title',
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  BlogEditor(
                    controller: contentController,
                    hintText: 'Blog content',
                  )
                ],
              ),
            ),
          );
        }));
  }
}
