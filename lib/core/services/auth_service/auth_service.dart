import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // -- Signup with Email and OTP
  Future<AuthResponse> signupWithEmailOtp(
      String email,
      String password,
      String fullName,
      bool isVendor,
      ) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'is_vendor': isVendor,
      },
    );

    return response;
  }

  // -- Verify OTP
  Future<AuthResponse> verifyOtp(String email, String otp) async {
    final response = await _supabase.auth.verifyOTP(
      email: email,
      token: otp,
      type: OtpType.signup,
    );
    if (response.user == null) {
      throw Exception('Failed to verify OTP');
    }
    return response;
  }

  Future<void> resendOtp(String email) async {
    try {
      // Sign up with a temporary password to trigger OTP resend
      final response = await _supabase.auth.signUp(
        email: email,
        password: 'temporarypassword123',
      );

      // Checking if response contains an error
      if (response.user == null) {
        throw Exception('Failed to resend OTP');
      }
      print("OTP resent successfully.");
    } catch (e) {
      // Handle any other errors (network, invalid email, etc.)
      print("Failed to resend OTP: ${e.toString()}");
      throw Exception('Failed to resend OTP: ${e.toString()}');
    }
  }

  // -- Login with Email and Password
  Future<AuthResponse> loginWithEmailPassword(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // -- Logout
  Future<void> logOut() async {
    await _supabase.auth.signOut();
  }

  // -- Get Current User's Email
  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
}