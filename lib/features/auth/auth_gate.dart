import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickdeal/core/services/routes/app_routes.dart';
import 'package:quickdeal/core/utils/helpers/helpers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: AppHelperFunctions.appLoader(context));
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          final session = snapshot.data?.session;
          final router = GoRouter.of(context);

          if (session != null) {
            router.go(AppRoutes.clientHome);
          } else {
            router.go(AppRoutes.login);
          }
        });

        return const SizedBox();
      },
    );
  }
}