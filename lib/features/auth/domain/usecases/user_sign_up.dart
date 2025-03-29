import 'package:fpdart/fpdart.dart';
import 'package:quickdeal/core/error/failures.dart';
import 'package:quickdeal/core/usecase/usecase.dart';
import 'package:quickdeal/features/auth/domain/entities/user.dart';
import 'package:quickdeal/features/auth/domain/repository/auth_repository.dart';

class UserSignUpParams {
  final String fullName;
  final String email;
  final String password;

  UserSignUpParams({
    required this.fullName,
    required this.email,
    required this.password,
  });
}

class UserSignUp implements UseCase<User, UserSignUpParams> {
  final AuthRepository authRepository;

  const UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailPassword(
      fullName: params.fullName,
      email: params.email,
      password: params.password,
    );
  }
}
