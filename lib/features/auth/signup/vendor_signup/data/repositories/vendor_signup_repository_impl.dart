import 'package:dartz/dartz.dart';
import '../../../../../../core/utils/errors/failures.dart';
import '../../domain/entities/vendor_entity.dart';
import '../../domain/repositories/vendor_signup_repository.dart';
import '../datasource/vendor_signup_remote_datasource.dart';

class VendorSignupRepositoryImpl implements VendorSignupRepository {
  final VendorSignupRemoteDataSource remoteDataSource;

  VendorSignupRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, VendorEntity>> getVendorSignup() async {
    try {
      final signup = await remoteDataSource.getVendorSignup();
      return Right(signup);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> saveVendorSignup(VendorEntity signup) async {
    try {
      final result = await remoteDataSource.saveVendorSignup(signup);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> submitVendorSignup(VendorEntity signup)
  async {
    try {
      final result = await remoteDataSource.submitVendorSignup(signup);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}