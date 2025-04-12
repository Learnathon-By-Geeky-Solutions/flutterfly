// lib/features/auth/notifier/login_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickdeal/core/services/auth_service/auth_service.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>(
      (ref) => LoginNotifier(AuthService()),
);

class LoginNotifier extends StateNotifier<LoginState> {
  final AuthService _authService;

  LoginNotifier(this._authService) : super(LoginState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null, success: false);

    try {
      final response = await _authService.loginWithEmailPassword(email, password);

      if (response.user != null) {
        state = state.copyWith(isLoading: false, success: true);
      } else {
        throw Exception("Invalid credentials or user not found.");
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''), success: false,
      );
    }
  }
}


class LoginState {
  final bool isLoading;
  final bool success;
  final String? error;

  const LoginState({this.isLoading = false, this.error, this.success = false});

  LoginState copyWith({bool? isLoading, String? error, required bool success}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error
    );
  }
}
