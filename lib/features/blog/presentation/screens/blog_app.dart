import 'package:blog_application/features/blog/presentation/screens/add_new_blog_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlogApp extends StatelessWidget {
  const BlogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blog App"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddNewBlogPage(),
                ),
              );
            },
            icon: const Icon(CupertinoIcons.add_circled),
          ),
        ],
      ),
    );
  }
}
