import '../../domain/entities/vendor_entity.dart';

class VendorModel extends VendorEntity {
  const VendorModel({
    required super.businessName,
    required super.businessType,
    required super.streetAddress,
    required super.city,
    required super.state,
    required super.zipCode,
    required super.phoneNumber,
    required super.emailAddress,
    required super.taxIdNumber,
    super.currentStep,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      businessName: json['businessName'] ?? '',
      businessType: json['businessType'] ?? '',
      streetAddress: json['streetAddress'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipCode: json['zipCode'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      emailAddress: json['emailAddress'] ?? '',
      taxIdNumber: json['taxIdNumber'] ?? '',
      currentStep: json['currentStep'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businessName': businessName,
      'businessType': businessType,
      'streetAddress': streetAddress,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'phoneNumber': phoneNumber,
      'emailAddress': emailAddress,
      'taxIdNumber': taxIdNumber,
      'currentStep': currentStep,
    };
  }

  factory VendorModel.empty() {
    return const VendorModel(
      businessName: '',
      businessType: '',
      streetAddress: '',
      city: '',
      state: '',
      zipCode: '',
      phoneNumber: '',
      emailAddress: '',
      taxIdNumber: '',
      currentStep: 1,
    );
  }
}