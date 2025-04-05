import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quickdeal/core/utils/theme/custom_themes/account_button_theme.dart';
import 'package:quickdeal/common/widget/getLogoWidget.dart';
import '../../../../../../common/widget/custom_snackbar.dart';
import '../../../../../../core/services/auth_service/auth_service.dart';
import '../../../../../../core/services/routes/app_routes.dart';
import '../../../../../../core/utils/errors/authErrors/auth_errors.dart';
import '../../../../../../l10n/generated/app_localizations.dart';
import '../controllers/client_signup_controller.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final authService = AuthService();

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
  void clientSignup() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      await authService.signupWithEmailOtp(email, password);

      if (mounted) {
        CustomSnackbar.show(
          context,
          message: 'OTP sent to $email',
          type: SnackbarType.success,
        );
        // Redirect to OTP screen for verification
        context.push(AppRoutes.emailOtpScreen, extra: email);
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.show(
          context,
          message: AuthErrors.toMessage(e),
          type: SnackbarType.error,
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final accountButtonTheme = Theme.of(context).extension<AccountButtonTheme>()!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final bool isPersonalSelected = _accountType == 'personal';
    final bool isBusinessSelected = _accountType == 'business';

    final signupProvider = StateNotifierProvider<SignupNotifier, SignupState>((ref) {
      return SignupNotifier();
    });

    final signupState = ref.watch(signupProvider);
    final signupNotifier = ref.read(signupProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with logo and help button
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
                      loc.needHelp,
                      style: textTheme.labelMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Signup title
              Center(
                child: Text(
                  loc.createAccount,
                  style: textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle
              Center(
                child: Text(
                  loc.chooseAccountType,
                  style: textTheme.titleSmall,
                ),
              ),
              const SizedBox(height: 24),
              // Account type selection
              Row(
                children: [
                  // Personal account selection
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
                              loc.personalAccount,
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
                  // Business account selection
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
                              loc.businessAccount,
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
                loc.fullName,
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  hintText: loc.enterFullName,
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              // Email Address
              Text(
                loc.emailAddress,
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: loc.emailExample,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),
              // Password
              Text(
                loc.password,
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: loc.createPassword,
                  prefixIcon: const Icon(Icons.help_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
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
                loc.confirmPassword,
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  hintText: loc.confirmPasswordHint,
                  prefixIcon: const Icon(Icons.help_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
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
              // Become a Vendor Section
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
                          loc.becomeVendor,
                          style: textTheme.bodyLarge,
                        ),
                        Text(
                          loc.sellProducts,
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
              // Create Account Button (or Continue Button)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_becomeVendor) {
                      // Navigate to the vendor screen
                      context.pushReplacement(AppRoutes.vendorSignupBusinessInfoScreen);
                    } else {
                      // Handle account creation logic
                      // For now, just navigate to the next screen
                      //context.go(AppRoutes.home);
                      clientSignup();
                    }
                  },
                  child: Text(
                    _becomeVendor ? loc.continueButton : loc.createAccountButton,
                    style: textTheme.labelLarge?.copyWith(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Already have an account? Log in.
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      loc.haveAccount,
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
                        loc.login,
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Terms and Privacy Policy
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Text(
                      loc.agreeTermsPart1,
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to Terms of Service page
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        loc.termsOfService,
                        style: textTheme.labelMedium,
                      ),
                    ),
                    Text(
                      loc.and,
                      style: textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to Privacy Policy page
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        loc.privacyPolicy,
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
