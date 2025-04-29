import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickdeal/common/widget/custom_snackbar.dart';
import 'package:quickdeal/core/services/auth_service/auth_service.dart';
import 'package:quickdeal/core/services/routes/app_routes.dart';

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
              _showLogoutDialog(context);
            },
            child: const Text('Logout',  style: TextStyle(fontSize: 10),),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), // Use Navigator.pop to close dialog
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 10),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5A7E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              _logout(context);
            },
            child: const Text('Logout',  style: TextStyle(fontSize: 10),),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    final authService = AuthService();
    authService.logOut();

    context.go(AppRoutes.authGate);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!context.mounted) return;
      CustomSnackbar.show(
        context,
        message: 'You have been logged out successfully.',
        type: SnackbarType.success,
      );
    });
  }
}
