import 'package:supabase_flutter/supabase_flutter.dart';

class AuthErrors {
  static String toMessage(dynamic error)
  {
    if (error is AuthException) {
      switch (error.message.toLowerCase())
      {
        case "invalid login credentials":
          return "Incorrect email or password. Please try again.";
        case "user already registered":
          return "This email is already registered. Try logging in.";
        case "email not confirmed":
          return "Email not verified. Please check your inbox.";
        case "password should be at least 6 characters":
          return "Weak password. Use at least 6 characters.";
        case "network request failed":
          return "No internet connection. Please check your network.";
        default:
          return error.message;
      }
    }
    return "Something went wrong. Please try again.";
  }
}