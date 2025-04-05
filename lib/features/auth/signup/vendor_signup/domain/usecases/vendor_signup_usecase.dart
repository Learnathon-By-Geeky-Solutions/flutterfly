import 'package:dartz/dartz.dart';
import 'package:quickdeal/features/auth/signup/vendor_signup/domain/repositories/vendor_signup_repository.dart';
import '../../../../../../core/utils/errors/failures.dart';
import '../entities/vendor_entity.dart';

class SubmitVendorSignup {
  final VendorSignupRepository repository;

  SubmitVendorSignup(this.repository);

  Future<Either<Failure, bool>> call(VendorEntity signup) {
    return repository.submitVendorSignup(signup);
  }
}

class SaveVendorSignup {
  final VendorSignupRepository repository;

  SaveVendorSignup(this.repository);

  Future<Either<Failure, bool>> call(VendorEntity registration) {
    return repository.saveVendorSignup(registration);
  }
}

class GetVendorSignup {
  final VendorSignupRepository repository;

  GetVendorSignup(this.repository);

  Future<Either<Failure, VendorEntity>> call() {
    return repository.getVendorSignup();
  }
}