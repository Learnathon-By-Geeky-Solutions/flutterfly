import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quickdeal/common/widget/getLogoWidget.dart';
import 'package:quickdeal/common/widget/input_form_field.dart';
import 'package:quickdeal/core/utils/constants/image_strings.dart';
import '../../../../../core/services/routes/app_routes.dart';
import '../../../../../core/utils/validators/validators.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);
    final loginNotifier = ref.read(loginProvider.notifier);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Get localization data, with null safety checks
    final loc = AppLocalizations.of(context);
    if (loc == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Listen for errors and show them via SnackBar.
    ref.listen<LoginState>(loginProvider, (_, state) {
      if (state.error != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.error!)));
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo widget.
                    getLogoBasedOnTheme(context, width: 250, height: 100),
                    const SizedBox(height: 16),
                    Text(loc.welcomeBack, style: textTheme.displayLarge),
                    const SizedBox(height: 8),
                    Text(loc.secureDeals,
                        style: textTheme.titleSmall, textAlign: TextAlign.center),
                    const SizedBox(height: 32),

                    // Email field
                    InputFormField(
                      key: const Key('email-field'),
                      textEditingController: _emailController,
                      hintText: loc.emailHint,
                      enableDefaultValidation: true,
                      validator: (value) => Validators.validateEmail(value, loc),
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    InputFormField(
                      key: const Key('password-field'),
                      textEditingController: _passwordController,
                      hintText: loc.passwordHint,
                      enableDefaultValidation: true,
                      password: const EnabledPassword(),
                      validator: (value) => Validators.validatePassword(
                        value,
                        loc,
                        minLength: 8,
                        requireUppercase: true,
                        requireDigit: true,
                        requireSpecialChar: true,
                        disallowSpaces: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Remember me & forgot password.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) =>
                                  setState(() => _rememberMe = value ?? false),
                            ),
                            Text(loc.rememberMe, style: textTheme.labelMedium),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // Handle forgot password action.
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: colorScheme.secondary,
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(loc.forgotPassword,
                              style: textTheme.labelMedium),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Sign in button.
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        key: const Key('login-button'),
                        onPressed: () {
                          if (loginState.isLoading) return;
                          if (_formKey.currentState!.validate()) {
                            loginNotifier.login(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                          }
                        },
                        child: loginState.isLoading
                            ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : Text(loc.logIn, style: textTheme.labelLarge
                            ?.copyWith(color: Colors.white)),
                      ),
                    ),

                    const SizedBox(height: 24),
                    // Divider with text.
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(loc.orContinue, style: textTheme.labelMedium),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Google sign in button.
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          // Handle Google sign in action.
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(ImageStrings.googleLogo, height: 18),
                            const SizedBox(width: 12),
                            Text(loc.googleLogin, style: textTheme.labelMedium),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Sign up option.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(loc.noAccount, style: textTheme.labelMedium),
                        TextButton(
                          onPressed: () => context.go(AppRoutes.clientSignup),
                          style: TextButton.styleFrom(
                            foregroundColor: colorScheme.secondary,
                            padding: const EdgeInsets.only(left: 4),
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(loc.signUp,
                              style: textTheme.labelLarge
                                  ?.copyWith(color: colorScheme.secondary)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
