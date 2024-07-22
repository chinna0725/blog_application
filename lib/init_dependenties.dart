import 'package:blog_application/core/commom/cubits/app_user/app_user_cubit.dart';
import 'package:blog_application/features/auth/data/data_source/auth_remote_datasource.dart';
import 'package:blog_application/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_application/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_application/features/auth/domain/usecase/current_user.dart';
import 'package:blog_application/features/auth/domain/usecase/user_sign_in.dart';
import 'package:blog_application/features/auth/domain/usecase/user_sign_up.dart';
import 'package:blog_application/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  FirebaseApp app = await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyBJLysZGxx_sffU3kSKW-7PwOPMpYwNUW4',
          appId: '1:961597078514:android:49c1b586578e270012c96b',
          messagingSenderId: '961597078514',
          projectId: 'blog-app-e2268'));

  FirebaseAuth auth = FirebaseAuth.instanceFor(app: app);

  FirebaseFirestore dp = FirebaseFirestore.instance;
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
