import 'package:blog_application/core/error/excepetions.dart';
import 'package:blog_application/features/blog/data/models/blog_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blogModel);
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final FirebaseFirestore dp;

  BlogRemoteDataSourceImpl({required this.dp});

  @override
  Future<BlogModel> uploadBlog(BlogModel blogModel) async {
    try {
      await dp
          .collection('blogs')
          .doc("all")
          .set(blogModel.toJson())
          .then((value) {});

      return blogModel;
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }
}
