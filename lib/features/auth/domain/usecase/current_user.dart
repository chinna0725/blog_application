import 'package:blog_application/core/entities/user.dart';
import 'package:blog_application/core/error/failures.dart';
import 'package:blog_application/core/usecase/usecase.dart';
import 'package:blog_application/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

final class CurrentUser implements UseCase<User, NoParams> {
  final AuthRepository authRepository;

  CurrentUser({required this.authRepository});
  @override
  Future<Either<Failure, User>> call(NoParams params) {
    return authRepository.currentUser();
  }
}
