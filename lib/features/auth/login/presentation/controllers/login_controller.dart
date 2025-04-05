// lib/features/auth/notifier/login_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier();
});

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(const LoginState());

  // Simulate the login process.
  Future<void> login(String email, String password) async {
    // Start loading and reset any previous error
    state = state.copyWith(isLoading: true, error: null);

    // Simulate a network delay (e.g., API call)
    await Future.delayed(const Duration(seconds: 2));

    // Check the credentials (this is just a mock, you should replace it with real logic)
    if (email == 'test@example.com' && password == 'Password123!') {
      // Simulate successful login
      state = state.copyWith(isLoading: false, error: null);
      // Navigate to dashboard screen of either client or vendor

    } else {
      // Simulate failed login
      state = state.copyWith(isLoading: false, error: 'Invalid credentials');
    }
  }
}

class LoginState {
  final bool isLoading;
  final String? error;

  const LoginState({this.isLoading = false, this.error});

  LoginState copyWith({bool? isLoading, String? error}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
