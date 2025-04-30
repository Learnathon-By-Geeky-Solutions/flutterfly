import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickdeal/common/widget/custom_appbar.dart';
import 'package:quickdeal/common/widget/custom_snackbar.dart';
import 'package:quickdeal/core/services/auth_service/auth_service.dart';
import 'package:quickdeal/core/services/routes/app_routes.dart';
import 'package:quickdeal/core/utils/helpers/helpers.dart';

import '../../../main.dart';


class ClientProfile extends StatefulWidget {
  const ClientProfile({super.key});

  @override
  _ClientProfileState createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {
  bool _isLoading = true;
  Map<String, dynamic>? _clientInfo;

  @override
  void initState() {
    super.initState();
    _fetchClientInfo();
  }

  Future<void> _fetchClientInfo() async {
    try {
      final clientId = supabase.auth.currentUser?.id;
      final response = await supabase
          .from('clients')
          .select('*')
          .eq('client_id', clientId as Object)
          .single();

      setState(() {
        _clientInfo = response;
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching client info: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _isLoading
          ? Center(child: AppHelperFunctions.appLoader(context))
          : _clientInfo == null
          ? Center(child: Text('No client data found'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                _clientInfo?['profile_pic'] ??
                    'https://www.example.com/default-avatar.png',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _clientInfo?['full_name'] ?? 'No Name',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _clientInfo?['email'] ?? 'No Email',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Address: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _clientInfo?['address'] ?? 'Not provided',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Contact Number: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _clientInfo?['contact_number'] ??
                            'Not provided',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bkash Number: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _clientInfo?['client_bkash_number'] ??
                            'Not provided',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showLogoutDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
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
            onPressed: () => Navigator.pop(ctx),
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
            child: const Text(
              'Logout',
              style: TextStyle(fontSize: 10),
            ),
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
