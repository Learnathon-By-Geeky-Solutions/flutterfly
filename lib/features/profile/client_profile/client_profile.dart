import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickdeal/core/services/auth_service/auth_service.dart';
import 'package:quickdeal/core/services/routes/app_routes.dart';

class ClientProfile extends StatelessWidget {
  const ClientProfile({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Client Profile'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final router = GoRouter.of(context);
              try {
                await authService.logOut();
                router.go(AppRoutes.login);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout failed: $e')),
                );
              }
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
