import 'package:fpdart/fpdart.dart';
import 'package:quickdeal/core/error/exceptions.dart';
import 'package:quickdeal/core/error/failures.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../domain/entities/user.dart';
import '../../domain/repository/login_repository.dart';
import '../datasources/login_remote_data_source.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
    try {
      final user = await fn();
      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
