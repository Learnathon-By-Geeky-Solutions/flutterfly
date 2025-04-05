class VendorEntity {
  final String businessName;
  final String businessType;
  final String streetAddress;
  final String city;
  final String state;
  final String zipCode;
  final String phoneNumber;
  final String emailAddress;
  final String taxIdNumber;
  final int currentStep;

  const VendorEntity({
    required this.businessName,
    required this.businessType,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.phoneNumber,
    required this.emailAddress,
    required this.taxIdNumber,
    this.currentStep = 1,
  });

  VendorEntity copyWith({
    String? businessName,
    String? businessType,
    String? streetAddress,
    String? city,
    String? state,
    String? zipCode,
    String? phoneNumber,
    String? emailAddress,
    String? taxIdNumber,
    int? currentStep,
  }) {
    return VendorEntity(
      businessName: businessName ?? this.businessName,
      businessType: businessType ?? this.businessType,
      streetAddress: streetAddress ?? this.streetAddress,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emailAddress: emailAddress ?? this.emailAddress,
      taxIdNumber: taxIdNumber ?? this.taxIdNumber,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}