import 'package:go_router/go_router.dart';
import 'package:quickdeal/features/auth/signup/email_otp_screen.dart';
import 'package:quickdeal/features/auth/signup/vendor_signup/presentation/screens/vendor_signup_verification_screen.dart';
import 'package:quickdeal/features/home/client_home/client_home.dart';
import '../../../../features/splash/presentation/splash_screen.dart';
import '../../../features/auth/login/presentation/screens/login_screen.dart';
import '../../../features/auth/signup/client_signup/presentation/screens/client_signup_screen.dart';
import '../../../features/auth/signup/vendor_signup/presentation/screens/vendor_signup_business_info_screen.dart';
import 'app_routes.dart';

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
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
      path: AppRoutes.vendorSignupVerificationScreen,
      builder: (context, state) => const VendorVerificationPage(),
    ),
    GoRoute(
      path: AppRoutes.emailOtpScreen,
      builder: (context, state) {
        final email = state.extra as String;
        return EmailOtpScreen(email: email);
      },
    ),
    GoRoute(
      path: AppRoutes.clientHome,
      builder: (context, state) => const ClientHome(),
    ),
  ]
);
