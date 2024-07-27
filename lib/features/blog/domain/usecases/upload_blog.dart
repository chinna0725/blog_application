import 'dart:io';

import 'package:blog_application/core/error/failures.dart';
import 'package:blog_application/core/usecase/usecase.dart';
import 'package:blog_application/features/blog/domain/entities/blog.dart';
import 'package:blog_application/features/blog/domain/repositories/blog_repositories.dart';
import 'package:fpdart/fpdart.dart';

class UploadBlog implements UseCase<Blog, UploadBlogParams> {
  final BlogRepositories blogRepositories;

  UploadBlog({required this.blogRepositories});
  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams params) async {
  return await  blogRepositories.uploadBlog(
      imageFile: params.imageFile,
      title: params.title,
      content: params.content,
      posterId: params.posterId,
      topics: params.topics,
    );
  }
}

class UploadBlogParams {
  final String posterId;
  final String title;
  final String content;
  final File imageFile;
  final List<String> topics;

  UploadBlogParams({
    required this.posterId,
    required this.title,
    required this.content,
    required this.imageFile,
    required this.topics,
  });
}
