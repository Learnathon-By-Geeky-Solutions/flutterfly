import 'package:dartz/dartz.dart';
import '../../../../../../core/utils/errors/failures.dart';
import '../entities/vendor_entity.dart';

abstract class VendorSignupRepository {
  Future<Either<Failure, bool>> submitVendorSignup(VendorEntity signup);
  Future<Either<Failure, VendorEntity>> getVendorSignup();
  Future<Either<Failure, bool>> saveVendorSignup(VendorEntity signup);
}