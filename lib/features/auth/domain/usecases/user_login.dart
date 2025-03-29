import 'package:fpdart/fpdart.dart';
import 'package:quickdeal/core/error/failures.dart';
import 'package:quickdeal/core/usecase/usecase.dart';
import 'package:quickdeal/features/auth/domain/entities/user.dart';
import 'package:quickdeal/features/auth/domain/repository/auth_repository.dart';

class UserLogin implements UseCase<User, UserLoginParams> {
  final AuthRepository authRepsoitory;
  const UserLogin(this.authRepsoitory);
  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async {
    return await authRepsoitory.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams({required this.email, required this.password});
}
