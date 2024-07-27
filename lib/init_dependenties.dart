import 'package:blog_application/core/commom/cubits/app_user/app_user_cubit.dart';
import 'package:blog_application/features/auth/data/data_source/auth_remote_datasource.dart';
import 'package:blog_application/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_application/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_application/features/auth/domain/usecase/current_user.dart';
import 'package:blog_application/features/auth/domain/usecase/user_sign_in.dart';
import 'package:blog_application/features/auth/domain/usecase/user_sign_up.dart';
import 'package:blog_application/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_application/features/blog/data/data_sources/blog_remote_data_source.dart';
import 'package:blog_application/features/blog/data/repositories/blog_repositories_impl.dart';
import 'package:blog_application/features/blog/domain/repositories/blog_repositories.dart';
import 'package:blog_application/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog_application/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  FirebaseApp app =
   await Firebase.initializeApp(
    // name: 'blog-app-e2268',
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBJLysZGxx_sffU3kSKW-7PwOPMpYwNUW4',
      appId: '1:961597078514:android:49c1b586578e270012c96b',
      messagingSenderId: '961597078514',
      projectId: 'blog-app-e2268',
      storageBucket: "blog-app-e2268.appspot.com",
    ),
  );

  FirebaseAuth auth = FirebaseAuth.instanceFor(app: app);

  FirebaseFirestore dp = FirebaseFirestore.instanceFor(app: app);

  FirebaseStorage storage = FirebaseStorage.instanceFor(
      app: app, bucket: 'gs://blog-app-e2268.appspot.com');

  serviceLocator.registerLazySingleton(() => storage);
  serviceLocator.registerLazySingleton(() => dp);

  serviceLocator.registerLazySingleton(() => auth);

  //core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  serviceLocator

    //remote data source
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImplimentation(
          firebaseAuth: serviceLocator(), dp: serviceLocator()),
    )

    // repo
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
      ),
    )

    // use case
    ..registerFactory<UserSignUp>(
      () => UserSignUp(
        authRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserSignIn(
        authRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        authRepository: serviceLocator(),
      ),
    )

    // auth bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userSignIn: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        dp: serviceLocator(),
        storage: serviceLocator(),
      ),
    )
    ..registerFactory<BlogRepositories>(
      () => BlogRepositoryImpl(
        blogRemoteDataSource: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UploadBlog(
        blogRepositories: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
      ),
    );
}
