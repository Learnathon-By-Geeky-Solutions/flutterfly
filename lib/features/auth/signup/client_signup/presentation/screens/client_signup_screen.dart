import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quickdeal/core/services/auth_service/auth_service.dart';
import 'package:quickdeal/core/utils/constants/color_palette.dart';
import 'package:quickdeal/common/widget/custom_snackbar.dart';
import 'package:quickdeal/core/utils/theme/custom_themes/account_button_theme.dart';
import 'package:quickdeal/common/widget/input_form_field.dart';
import '../../../../../../common/widget/getLogoWidget.dart';
import '../../../../../../core/utils/validators/validators.dart';
import '../../../../../../l10n/generated/app_localizations.dart';
import '../../../../../../core/services/routes/app_routes.dart';
import '../controllers/client_signup_notifier.dart';
import '../providers/client_signup_provider.dart';
import '../state/client_signup_state.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final clientSignupNotifierProvider = StateNotifierProvider<ClientSignupNotifier, ClientSignupState>(
        (ref) => ClientSignupNotifier(ref.read(signupUseCaseProvider)),
  );

  bool _becomeVendor = false;
  String _accountType = 'personal';

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void clientSignup() async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final notifier = ref.read(clientSignupNotifierProvider.notifier);

    if (mounted) {
      AuthService authService = AuthService();
      await authService.signupWithEmailOtp(email, password);

      CustomSnackbar.show(
        context,
        message: 'OTP sent to $email',
        type: SnackbarType.success,
      );
      context.go(AppRoutes.emailOtpScreen, extra: email);
    } else {
      final errorMessage = ref.read(clientSignupNotifierProvider).errorMessage;
      CustomSnackbar.show(
        context,
        message: errorMessage ?? 'An error occurred',
        type: SnackbarType.error,
      );
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
    final isLoading = ref.watch(clientSignupNotifierProvider).isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getLogoBasedOnTheme(context, width: 150, height: 50),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.tertiary,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(loc.needHelp, style: textTheme.labelMedium),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(child: Text(loc.createAccount, style: textTheme.titleLarge)),
                const SizedBox(height: 8),
                Center(child: Text(loc.chooseAccountType, style: textTheme.titleSmall)),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _accountType = 'personal'),
                        child: _accountTypeButton(
                          loc.personalAccount,
                          Icons.person_outline,
                          isPersonalSelected,
                          accountButtonTheme,
                          textTheme,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _accountType = 'business'),
                        child: _accountTypeButton(
                          loc.businessAccount,
                          Icons.business_outlined,
                          isBusinessSelected,
                          accountButtonTheme,
                          textTheme,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                InputFormField(
                  textEditingController: _fullNameController,
                  labelText: loc.fullName,
                  hintText: loc.enterFullName,
                  prefix: const Icon(Icons.person_outline),
                  validator: (value) => value == null || value.trim().isEmpty ? loc.requiredField : null,
                ),
                const SizedBox(height: 16),
                InputFormField(
                  textEditingController: _emailController,
                  labelText: loc.emailAddress,
                  hintText: loc.emailExample,
                  prefix: const Icon(Icons.email_outlined),
                  validator: (value) => Validators.validateEmail(value, loc),
                  errorColor: AppColors.errorRed,
                ),
                const SizedBox(height: 16),
                InputFormField(
                  textEditingController: _passwordController,
                  labelText: loc.password,
                  hintText: loc.createPassword,
                  password: EnabledPassword(),
                  prefix: const Icon(Icons.lock_outline),
                  validator: (value) => Validators.validatePassword(
                    value,
                    loc,
                    minLength: 6,
                    requireUppercase: true,
                    requireDigit: true,
                    requireSpecialChar: true,
                    disallowSpaces: true,
                  ),
                  errorColor: AppColors.errorRed,
                ),
                const SizedBox(height: 16),
                InputFormField(
                  textEditingController: _confirmPasswordController,
                  labelText: loc.confirmPassword,
                  hintText: loc.confirmPasswordHint,
                  password: const EnabledPassword(),
                  prefix: const Icon(Icons.lock_outline),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return loc.requiredField;
                    } else if (value != _passwordController.text) {
                      return loc.passwordMismatch;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(loc.becomeVendor, style: textTheme.bodyLarge),
                          Text(loc.sellProducts, style: textTheme.bodyMedium),
                        ],
                      ),
                      Switch(
                        value: _becomeVendor,
                        onChanged: (value) => setState(() => _becomeVendor = value),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.black12,
                        activeColor: Colors.white,
                        activeTrackColor: colorScheme.secondary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                      if (_formKey.currentState?.validate() ?? false) {
                        clientSignup();
                      }
                    },
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                      _becomeVendor ? loc.continueButton : loc.createAccountButton,
                      style: textTheme.labelLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(loc.haveAccount, style: textTheme.labelMedium),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.login),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.only(left: 4),
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          loc.login,
                          style: textTheme.labelMedium?.copyWith(color: colorScheme.secondary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(loc.agreeTermsPart1, style: textTheme.bodyMedium, textAlign: TextAlign.center),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(loc.termsOfService, style: textTheme.labelMedium),
                      ),
                      Text(loc.and, style: textTheme.bodyMedium),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(loc.privacyPolicy, style: textTheme.labelMedium),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _accountTypeButton(String label, IconData icon, bool isSelected, AccountButtonTheme theme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isSelected ? theme.selectedColor : theme.unselectedColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isSelected ? theme.selectedColor : theme.borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? theme.selectedTextColor : theme.unselectedTextColor),
          const SizedBox(height: 8),
          Text(
            label,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: isSelected ? theme.selectedTextColor : theme.unselectedTextColor,
            ),
          ),
        ],
      ),
    );
  }
}