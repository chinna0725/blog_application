import 'package:blog_application/core/entities/user.dart';
import 'package:blog_application/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_application/core/error/failures.dart';
import 'package:blog_application/core/usecase/usecase.dart';

import 'package:fpdart/fpdart.dart';

class UserSignIn implements UseCase<User, UserSignInParams> {
  final AuthRepository authRepository;

  UserSignIn({required this.authRepository});
  @override
  Future<Either<Failure, User>> call(UserSignInParams params) {
    return authRepository.signInWithEmailPassword(
        email: params.email, password: params.password);
  }
}

class UserSignInParams {
  final String email;
  final String password;

  UserSignInParams({required this.email, required this.password});
}
