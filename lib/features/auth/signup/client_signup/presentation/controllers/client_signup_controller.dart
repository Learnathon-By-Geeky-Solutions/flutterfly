import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  const SignupState({
    this.isLoading = false,
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

    // Simulating a network delay for signup
    await Future.delayed(const Duration(seconds: 2));

    // Simulating a success or error after the delay
    if (email == "test@example.com") {
      state = state.copyWith(isLoading: false, isSuccess: true);
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Signup failed. Please try again.',
        isSuccess: false,
      );
    }
  }
}