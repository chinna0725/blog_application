import 'dart:io';

import 'package:blog_application/core/error/excepetions.dart';
import 'package:blog_application/core/error/failures.dart';
import 'package:blog_application/features/blog/data/data_sources/blog_remote_data_source.dart';
import 'package:blog_application/features/blog/data/models/blog_models.dart';
import 'package:blog_application/features/blog/domain/entities/blog.dart';
import 'package:blog_application/features/blog/domain/repositories/blog_repositories.dart';
import 'package:fpdart/fpdart.dart';

class BlogRepositoryImpl implements BlogRepositories {
  final BlogRemoteDataSource blogRemoteDataSource;

  BlogRepositoryImpl({required this.blogRemoteDataSource});

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File imageFile,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      final imageUrl = await blogRemoteDataSource.uploadImage(
        imageFile: imageFile,
        id: "id",
      );
      BlogModel blogModel = BlogModel(
        id: "id",
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: imageUrl,
        topics: topics,
        updatedAt: DateTime.now(),
      );


    BlogModel blog= await blogRemoteDataSource.uploadBlog(blogModel);

    return right(blog);
    } on ServerExceptions catch (e) {
      return left(Failure(e.messege));
    }
  }
}
