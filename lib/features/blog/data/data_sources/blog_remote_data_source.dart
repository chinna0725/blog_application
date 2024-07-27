import 'dart:io';

import 'package:blog_application/core/error/excepetions.dart';
import 'package:blog_application/features/blog/data/models/blog_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blogModel);

  Future<String> uploadImage(
      {required File imageFile, required String id});
}

// implementaion----------------------------------
class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final FirebaseFirestore dp;
  final FirebaseStorage storage;

  BlogRemoteDataSourceImpl({required this.dp, required this.storage});

  @override
  Future<BlogModel> uploadBlog(BlogModel blogModel) async {
    try {
      await dp.collection('blogs').doc("all").set(blogModel.toJson());

      return blogModel;
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<String> uploadImage(
      {required File imageFile, required String id}) async {
    try {
      final url = await storage
          .ref()
          .child("user images/$imageFile")
          .putFile(imageFile)
          .snapshot
          .ref
          .getDownloadURL();
      return url.toString();
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }
}
