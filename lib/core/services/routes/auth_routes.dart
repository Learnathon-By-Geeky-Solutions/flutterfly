import 'package:go_router/go_router.dart';
import 'package:quickdeal/features/auth/auth_gate.dart';
import 'package:quickdeal/features/auth/login/presentation/screens/login_screen.dart';
import 'package:quickdeal/features/auth/signup/client_signup/presentation/screens/client_signup_screen.dart';
import 'package:quickdeal/features/auth/signup/vendor_signup/presentation/screens/vendor_signup_business_info_screen.dart';
import 'package:quickdeal/features/auth/signup/vendor_signup/presentation/screens/vendor_signup_services_screen.dart';
import 'package:quickdeal/features/auth/otp_screen/email_otp_screen.dart';
import 'package:quickdeal/features/splash/presentation/splash_screen.dart';
import 'app_routes.dart';

final List<GoRoute> authRoutes = [
  GoRoute(
    path: AppRoutes.authGate,
    builder: (context, state) => const AuthGate(),
  ),
  GoRoute(
    path: AppRoutes.splash,
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    path: AppRoutes.login,
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: AppRoutes.clientSignup,
    builder: (context, state) => const SignupScreen(),
  ),
  GoRoute(
    path: AppRoutes.vendorSignupBusinessInfoScreen,
    builder: (context, state) => const VendorSignupBusinessInfoScreen(),
  ),
  GoRoute(
    path: AppRoutes.vendorSignupServicesScreen,
    builder: (context, state) => const VendorSignupServicesScreen(),
  ),
  GoRoute(
    path: AppRoutes.emailOtpScreen,
    builder: (context, state) {
      final email = state.extra as String;
      return EmailOtpScreen(email: email);
    },
  ),
];