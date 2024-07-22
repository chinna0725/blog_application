import 'package:blog_application/core/entities/user.dart';
import 'package:blog_application/core/error/failures.dart';

import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailPassword(
      {required String name, required String email, required String password});

  Future<Either<Failure, User>> signInWithEmailPassword(
      {required String email, required String password});

  Future<Either<Failure, User>> currentUser();
}




// supabase database password @Vjc15403554