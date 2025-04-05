import 'package:quickdeal/features/auth/signup/vendor_signup/domain/entities/vendor_entity.dart';

import '../models/vendor_model.dart';

abstract class VendorSignupRemoteDataSource {
  Future<VendorEntity> getVendorSignup();
  Future<bool> saveVendorSignup(VendorEntity signup);
  Future<bool> submitVendorSignup(VendorEntity signup);
}

class VendorSignupRemoteDataSourceImpl implements VendorSignupRemoteDataSource {
  // In a real app, you would inject an HTTP client here

  @override
  Future<VendorEntity> getVendorSignup() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    return VendorModel.empty();
  }

  @override
  Future<bool> saveVendorSignup(VendorEntity signup) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  @override
  Future<bool> submitVendorSignup(VendorEntity signup) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}