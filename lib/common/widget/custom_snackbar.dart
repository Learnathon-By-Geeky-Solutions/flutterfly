import 'package:flutter/material.dart';

enum SnackbarType { success, error, warning, info }

class CustomSnackbar {
  static void show(BuildContext context, {required String message, required SnackbarType type}) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Define colors & icons for different types
    final Map<SnackbarType, Color> backgroundColors = {
      SnackbarType.success: Colors.green,
      SnackbarType.error: Colors.red,
      SnackbarType.warning: Colors.orange,
      SnackbarType.info: Colors.blue,
    };

    final Map<SnackbarType, IconData> icons = {
      SnackbarType.success: Icons.check_circle_outline,
      SnackbarType.error: Icons.error_outline,
      SnackbarType.warning: Icons.warning_amber_rounded,
      SnackbarType.info: Icons.info_outline,
    };

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icons[type], color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
          ],
        ),
        backgroundColor: backgroundColors[type],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
