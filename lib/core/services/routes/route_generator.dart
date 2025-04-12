import 'package:go_router/go_router.dart';
import 'package:quickdeal/features/auth/auth_gate.dart';
import 'package:quickdeal/features/auth/login/presentation/screens/login_screen.dart';
import 'package:quickdeal/features/auth/signup/client_signup/presentation/screens/client_signup_screen.dart';
import 'package:quickdeal/features/auth/signup/email_otp_screen.dart';
import 'package:quickdeal/features/auth/signup/vendor_signup/presentation/screens/vendor_signup_business_info_screen.dart';
import 'package:quickdeal/features/auth/signup/vendor_signup/presentation/screens/vendor_signup_verification_screen.dart';
import 'package:quickdeal/features/home/client_home/presentation/screens/client_home.dart';
import 'package:quickdeal/features/ongoing_bids/client_ongoing_bids.dart';
import 'package:quickdeal/features/profile/client_profile/client_profile.dart';
import 'package:quickdeal/features/rfq/client_add_request.dart';
import 'package:quickdeal/features/rfq/my_rfq.dart';
import 'package:quickdeal/features/splash/presentation/splash_screen.dart';
import '../../../common/widget/client_widgets/client_navbar_wrapper.dart';
import 'app_routes.dart';

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.authGate,
  routes: [
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
    ShellRoute(
      builder: (context, state, child) => ClientBottomNavBarWrapper(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.clientHome,
          name: 'client_home',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ClientHomeScreen(),
          ),
        ),
        GoRoute(
          path: '/my-rfqs',
          name: 'my_rfqs',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MyRfq(),
          ),
        ),
        GoRoute(
          path: '/add-request',
          name: 'add_request',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ClientAddRequest(),
          ),
        ),
        GoRoute(
          path: '/ongoing-bids',
          name: 'ongoing_bids',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ClientOngoingBids(),
          ),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ClientProfile(),
          ),
        ),
      ],
    ),
  ],
);