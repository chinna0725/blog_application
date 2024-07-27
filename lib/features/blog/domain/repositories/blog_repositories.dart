import 'dart:io';

import 'package:blog_application/core/error/failures.dart';
import 'package:blog_application/features/blog/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepositories {
  Future<Either<Failure, Blog>> uploadBlog({
    required File imageFile,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  });
}
