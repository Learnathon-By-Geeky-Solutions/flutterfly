import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../../core/utils/loggers/logger.dart';
import '../models/client_model.dart';

class AuthRemoteDataSource {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthResponse> signup(ClientModel clientModel) async {
    try {
      final response = await _supabase.auth.signUp(
        email: clientModel.email,
        password: clientModel.password,
      );

      // Check if the user is created successfully
      if (response.user != null) {
        final user = response.user!;
        await _supabase.auth.updateUser(
          UserAttributes(data: {'fullName': clientModel.fullName}),
        );
        Log.i("User signed up and fullName updated successfully: ${response.user?.email}");
        return response;
      } else {
        throw Exception('Signup failed, no user returned');
      }

    } catch (e) {
      Log.e("Failed to sign up: $e");
      throw Exception('Failed to sign up: $e');
    }
  }
}