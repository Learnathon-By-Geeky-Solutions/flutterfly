import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasource/vendor_signup_remote_datasource.dart';
import '../../data/models/vendor_model.dart';
import '../../data/repositories/vendor_signup_repository_impl.dart';
import '../../domain/usecases/vendor_signup_usecase.dart';

// State class
class VendorSignupState {
  final VendorModel signup;
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  VendorSignupState({
    required this.signup,
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  VendorSignupState copyWith({
    VendorModel? signup,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return VendorSignupState(
      signup: signup ?? this.signup,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

// Controller notifier
class VendorSignupController extends StateNotifier<VendorSignupState> {
  final SaveVendorSignup _saveVendorSignup;
  final SubmitVendorSignup _submitVendorSignup;
  final GetVendorSignup _getVendorSignup;

  // Form keys for validation
  final businessInfoFormKey = GlobalKey<FormState>();

  // Business type options
  final List<String> businessTypes = [
    'Retail',
    'Wholesale',
    'Manufacturing',
    'Service',
    'Technology',
    'Food & Beverage',
    'Healthcare',
    'Education',
    'Other'
  ];

  VendorSignupController(
      this._saveVendorSignup,
      this._submitVendorSignup,
      this._getVendorSignup,
      ) : super(VendorSignupState(signup: VendorModel.empty())) {
    // Load any existing data when controller is created
    _loadVendorSignup();
  }

  Future<void> _loadVendorSignup() async {
    state = state.copyWith(isLoading: true);
    final result = await _getVendorSignup();
    result.fold(
          (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
          (signup) => state = state.copyWith(
        isLoading: false,
        signup: signup as VendorModel,
      ),
    );
  }

  // Update individual fields
  void updateBusinessName(String value) {
    final updatedSignup = state.signup.copyWith(businessName: value);
    state = state.copyWith(signup: updatedSignup as VendorModel);
  }

  void updateBusinessType(String value) {
    final updatedSignup = state.signup.copyWith(businessType: value);
    state = state.copyWith(signup: updatedSignup as VendorModel);
  }

  void updateStreetAddress(String value) {
    final updatedSignup = state.signup.copyWith(streetAddress: value);
    state = state.copyWith(signup: updatedSignup as VendorModel);
  }

  void updateCity(String value) {
    final updatedSignup = state.signup.copyWith(city: value);
    state = state.copyWith(signup: updatedSignup as VendorModel);
  }

  void updateState(String value) {
    final updatedSignup = state.signup.copyWith(state: value);
    state = state.copyWith(signup: updatedSignup as VendorModel);
  }

  void updateZipCode(String value) {
    final updatedSignup = state.signup.copyWith(zipCode: value);
    state = state.copyWith(signup: updatedSignup as VendorModel);
  }

  void updatePhoneNumber(String value) {
    final updatedSignup = state.signup.copyWith(phoneNumber: value);
    state = state.copyWith(signup: updatedSignup as VendorModel);
  }

  void updateEmailAddress(String value) {
    final updatedSignup = state.signup.copyWith(emailAddress: value);
    state = state.copyWith(signup: updatedSignup as VendorModel);
  }

  void updateTaxIdNumber(String value) {
    final updatedSignup = state.signup.copyWith(taxIdNumber: value);
    state = state.copyWith(signup: updatedSignup as VendorModel);
  }

  // Save current progress
  Future<void> saveProgress() async {
    state = state.copyWith(isLoading: true);
    final result = await _saveVendorSignup(state.signup);
    result.fold(
          (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
          (success) => state = state.copyWith(
        isLoading: false,
      ),
    );
  }

  // Proceed to next step
  Future<bool> proceedToNextStep() async {
    if (!businessInfoFormKey.currentState!.validate()) {
      return false;
    }

    // Save form data
    businessInfoFormKey.currentState!.save();

    // Save progress
    await saveProgress();

    // Update step
    final updatedSignup = state.signup.copyWith(currentStep: 2);
    state = state.copyWith(signup: updatedSignup as VendorModel);

    return true;
  }

  // Submit the entire signup
  Future<void> submitSignup() async {
    state = state.copyWith(isLoading: true);
    final result = await _submitVendorSignup(state.signup);
    result.fold(
          (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
          (success) => state = state.copyWith(
        isLoading: false,
        isSuccess: true,
      ),
    );
  }

  // Form validation methods
  String? validateBusinessName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Business name is required';
    }
    return null;
  }

  String? validateBusinessType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a business type';
    }
    return null;
  }

  String? validateStreetAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Street address is required';
    }
    return null;
  }

  String? validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return 'City is required';
    }
    return null;
  }

  String? validateState(String? value) {
    if (value == null || value.isEmpty) {
      return 'State is required';
    }
    return null;
  }

  String? validateZipCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'ZIP code is required';
    }
    final zipRegExp = RegExp(r'^\d{5}(-\d{4})?$');
    if (!zipRegExp.hasMatch(value)) {
      return 'Enter a valid ZIP code';
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegExp = RegExp(r'^\(\d{3}\) \d{3}-\d{4}$');
    if (!phoneRegExp.hasMatch(value)) {
      return 'Enter a valid phone number: (123) 456-7890';
    }
    return null;
  }

  String? validateEmailAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email address is required';
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validateTaxIdNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tax ID number is required';
    }
    final taxIdRegExp = RegExp(r'^\d{2}-\d{7}$');
    if (!taxIdRegExp.hasMatch(value)) {
      return 'Enter a valid Tax ID (XX-XXXXXXX)';
    }
    return null;
  }
}

// Providers
final vendorSignupRepositoryProvider = Provider((ref) {
  final remoteDataSource = VendorSignupRemoteDataSourceImpl();
  return VendorSignupRepositoryImpl(remoteDataSource: remoteDataSource);
});

final saveVendorSignupProvider = Provider((ref) {
  final repository = ref.watch(vendorSignupRepositoryProvider);
  return SaveVendorSignup(repository);
});

final submitVendorSignupProvider = Provider((ref) {
  final repository = ref.watch(vendorSignupRepositoryProvider);
  return SubmitVendorSignup(repository);
});

final getVendorSignupProvider = Provider((ref) {
  final repository = ref.watch(vendorSignupRepositoryProvider);
  return GetVendorSignup(repository);
});

final vendorSignupControllerProvider = StateNotifierProvider<VendorSignupController, VendorSignupState>((ref) {
  final saveVendorSignup = ref.watch(saveVendorSignupProvider);
  final submitVendorSignup = ref.watch(submitVendorSignupProvider);
  final getVendorSignup = ref.watch(getVendorSignupProvider);

  return VendorSignupController(
    saveVendorSignup,
    submitVendorSignup,
    getVendorSignup,
  );
});