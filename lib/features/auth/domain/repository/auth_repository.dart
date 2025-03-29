import 'package:fpdart/fpdart.dart';
import 'package:quickdeal/core/error/failures.dart';
import 'package:quickdeal/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  //Method for signing up
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String fullName,
    required String email,
    required String password,
  });

  //Method for logging in
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });
}
