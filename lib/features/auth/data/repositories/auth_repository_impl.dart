import 'package:blog_application/core/entities/user.dart';
import 'package:blog_application/core/error/excepetions.dart';
import 'package:blog_application/core/error/failures.dart';
import 'package:blog_application/features/auth/data/data_source/auth_remote_datasource.dart';
import 'package:blog_application/features/auth/data/models/user_model.dart';
import 'package:blog_application/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  AuthRepositoryImpl(this.authRemoteDataSource);

  @override
  Future<Either<Failure, UserModel>> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final user = await authRemoteDataSource.signUpEmailWithPassword(
          name: name, email: email, password: password);
      return right(user);
    } on ServerExceptions catch (e) {
      return left(Failure(e.messege));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signInWithEmailPassword(
      {required String email, required String password}) async {
    try {
      final user = await authRemoteDataSource.signInEmailWithPassword(
          email: email, password: password);
      return right(user);
    } on ServerExceptions catch (e) {
      return left(Failure(e.messege));
    }
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      final user = await authRemoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure('User not logged in!'));
      }
      return right(user);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
