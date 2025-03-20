import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickdeal/core/utils/theme/custom_themes/account_button_theme.dart';
import '../../../../common/widget/getLogoWidget.dart';
import '../../../../core/routes/app_routes.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _becomeVendor = false;
  String _accountType = 'personal'; // 'personal' or 'business'

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountButtonTheme =
    Theme.of(context).extension<AccountButtonTheme>()!;
    final bool isPersonalSelected = _accountType == 'personal';
    final bool isBusinessSelected = _accountType == 'business';
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with logo and help
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getLogoBasedOnTheme(context, width: 150, height: 50),
                  TextButton(
                    onPressed: () {
                      // Handle help action
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.tertiary,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Need help?',
                      style: textTheme.labelMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Create account heading
              Center(
                child: Text(
                  'Create your account',
                  style: textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 8),

              // Subheading
              Center(
                child: Text(
                  'Choose your account type to get started',
                  style: textTheme.titleSmall,
                ),
              ),
              const SizedBox(height: 24),

              // Account type selection
              Row(
                children: [
                  // Personal account
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _accountType = 'personal';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isPersonalSelected
                              ? accountButtonTheme.selectedColor
                              : accountButtonTheme.unselectedColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isPersonalSelected
                                ? accountButtonTheme.selectedColor
                                : accountButtonTheme.borderColor,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_outline,
                              color: isPersonalSelected
                                  ? accountButtonTheme.selectedTextColor
                                  : accountButtonTheme.unselectedTextColor,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Personal',
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: isPersonalSelected
                                    ? accountButtonTheme.selectedTextColor
                                    : accountButtonTheme.unselectedTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Business account
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _accountType = 'business';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isBusinessSelected
                              ? accountButtonTheme.selectedColor
                              : accountButtonTheme.unselectedColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isBusinessSelected
                                ? accountButtonTheme.selectedColor
                                : accountButtonTheme.borderColor,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.business_outlined,
                              color: isBusinessSelected
                                  ? accountButtonTheme.selectedTextColor
                                  : accountButtonTheme.unselectedTextColor,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Business',
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: isBusinessSelected
                                    ? accountButtonTheme.selectedTextColor
                                    : accountButtonTheme.unselectedTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Full Name
              Text(
                'Full Name',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter your full name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),

              // Email Address
              Text(
                'Email Address',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'you@example.com',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),

              // Password
              Text(
                'Password',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Create a password',
                  prefixIcon: const Icon(Icons.help_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Confirm Password
              Text(
                'Confirm Password',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  hintText: 'Confirm your password',
                  prefixIcon: const Icon(Icons.help_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Become a Vendor
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Become a Vendor',
                          style: textTheme.bodyLarge,
                        ),
                        Text(
                          'Sell products on our platform',
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Switch(
                      value: _becomeVendor,
                      onChanged: (value) {
                        setState(() {
                          _becomeVendor = value;
                        });
                      },
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.black12,
                      activeColor: Colors.white,
                      activeTrackColor: colorScheme.secondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Create Account Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle account creation
                  },
                  child: Text(
                    'Create Account',
                    style: textTheme.labelLarge?.copyWith(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Already have an account
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: textTheme.labelMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        context.go(AppRoutes.login);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.only(left: 4),
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Log in',
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Terms and Privacy
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Text(
                      'By creating an account, you agree to our ',
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to Terms of Service
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Terms of Service',
                        style: textTheme.labelMedium,
                      ),
                    ),
                    Text(
                      ' & ',
                      style: textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to Privacy Policy
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Privacy Policy',
                        style: textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}