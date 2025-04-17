import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickdeal/core/services/auth_service/auth_service.dart';
import 'package:quickdeal/core/services/routes/app_routes.dart';
import 'package:quickdeal/app.dart'; // For navigatorKey

class ClientProfile extends StatelessWidget {
  const ClientProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Client Profile'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: const Text('Confirm Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actionsPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5A7E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        final authService = AuthService();
                        authService.logOut();
                        context.go(AppRoutes.authGate);

                        Future.delayed(const Duration(milliseconds: 300), () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text('Logged out successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        });
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}