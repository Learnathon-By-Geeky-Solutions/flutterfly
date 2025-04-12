import 'package:fpdart/fpdart.dart';
import 'package:quickdeal/core/error/failures.dart';
import '../entities/user.dart';

abstract interface class AuthRepository {
  //Method for logging in
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });
}
