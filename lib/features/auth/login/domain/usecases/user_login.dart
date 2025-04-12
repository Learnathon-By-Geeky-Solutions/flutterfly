import 'package:fpdart/fpdart.dart';
import 'package:quickdeal/core/error/failures.dart';
import 'package:quickdeal/core/usecase/usecase.dart';
import '../entities/user.dart';
import '../repository/login_repository.dart';



class UserLogin implements UseCase<User, UserLoginParams> {
  final AuthRepository authRepository;
  const UserLogin(this.authRepository);
  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async {
    return await authRepository.loginWithEmailPassword(
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
