import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickdeal/app.dart';
import 'package:quickdeal/core/services/auth_service/auth_service.dart';
import 'package:quickdeal/core/services/routes/app_routes.dart';

class VendorProfile extends StatelessWidget {
  const VendorProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Business Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Image
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFFF5A7E),
                        width: 3,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/body%20%283%29-4E7oq8BzTSZvBhbIhjXVedZ7lDdj9y.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF5A7E),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Business Name
            const Text(
              'TechPro Solutions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Business Description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Innovation-driven software development and consulting services',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Edit Profile Button
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5A7E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Edit Profile'),
              ),
            ),
            const SizedBox(height: 24),

            // Basic Details Section
            const SectionHeader(title: 'BASIC DETAILS'),
            DetailItem(
              title: 'Company Name',
              value: 'TechPro Solutions Inc.',
              hasArrow: true,
              onTap: () {},
            ),
            DetailItem(
              title: 'Registration Number',
              value: 'REG123456789',
              hasArrow: true,
              onTap: () {},
            ),
            DetailItem(
              title: 'Industry',
              value: 'Information Technology',
              hasArrow: true,
              onTap: () {},
            ),
            const SizedBox(height: 16),

            // Contact Information Section
            const SectionHeader(title: 'CONTACT INFORMATION'),
            ContactItem(
              icon: Icons.email_outlined,
              value: 'contact@techpro.com',
              onTap: () {},
            ),
            ContactItem(
              icon: Icons.phone_outlined,
              value: '+1 (555) 123-4567',
              onTap: () {},
            ),
            ContactItem(
              icon: Icons.location_on_outlined,
              value: '123 Tech Street, Silicon Valley, CA 94025',
              onTap: () {},
            ),
            const SizedBox(height: 16),

            // Account Settings Section
            const SectionHeader(title: 'ACCOUNT SETTINGS'),
            SettingsItem(
              icon: Icons.notifications_none,
              title: 'Notifications',
              hasArrow: false,
              onTap: () {},
            ),
            SettingsItem(
              icon: Icons.lock_outline,
              title: 'Privacy Settings',
              hasArrow: true,
              onTap: () {},
            ),
            SettingsItem(
              icon: Icons.credit_card,
              title: 'Payment Methods',
              hasArrow: true,
              onTap: () {},
            ),
            const SizedBox(height: 16),

            // Support & Help Section
            const SectionHeader(title: 'SUPPORT & HELP'),
            SettingsItem(
              icon: Icons.help_outline,
              title: 'Help Center',
              hasArrow: false,
              onTap: () {},
            ),
            SettingsItem(
              icon: Icons.description_outlined,
              title: 'Terms & Policies',
              hasArrow: false,
              onTap: () {},
            ),
            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: InkWell(
                onTap: () {
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
                              ScaffoldMessenger.of(context).showSnackBar(
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
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }
}

class DetailItem extends StatelessWidget {
  final String title;
  final String value;
  final bool hasArrow;
  final VoidCallback onTap;

  const DetailItem({
    Key? key,
    required this.title,
    required this.value,
    this.hasArrow = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (hasArrow)
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
          ],
        ),
      ),
    );
  }
}

class ContactItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final VoidCallback onTap;

  const ContactItem({
    super.key,
    required this.icon,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: Colors.grey[800],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool hasArrow;
  final VoidCallback onTap;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    this.hasArrow = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: Colors.grey[800],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            if (hasArrow)
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
          ],
        ),
      ),
    );
  }
}