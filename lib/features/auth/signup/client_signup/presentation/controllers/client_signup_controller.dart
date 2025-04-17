import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  const SignupState({
    this.isLoading = true,
    this.error,
    this.isSuccess = false,
  });

  // Copy method to update state values
  SignupState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return SignupState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class SignupNotifier extends StateNotifier<SignupState> {
  SignupNotifier() : super(const SignupState());

  // Simulating the signup process
  Future<void> signup(String fullName, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null, isSuccess: false);
  }
}