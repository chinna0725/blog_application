import 'dart:io';

import 'package:blog_application/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  BlogBloc({required UploadBlog uploadBlog})
      : _uploadBlog = uploadBlog,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) {});

    on<BlogUpload>(_onuploadBlog);
  }

  void _onuploadBlog(BlogUpload event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        imageFile: event.imageFile,
        topics: event.topics,
      ),
    );

    res.fold(
      (l) => emit(BlogFailure(message: l.message)),
      (r) => BlogSuccess(),
    );
  }
}
