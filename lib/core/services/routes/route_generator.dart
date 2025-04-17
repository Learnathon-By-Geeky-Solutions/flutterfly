import 'package:flutter/material.dart';
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
import '../../../common/widget/vendor_widgets/vendor_navbar_wrapper.dart';
import '../../../features/home/vendor_home/presentation/vendor_home.dart';
import '../../../features/unauthorized/unauthorized_screen.dart';
import '../role_manager/role_manager.dart';
import 'app_routes.dart';

UserRole userRole = getCurrentUserRole() as UserRole;

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
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ClientHomeScreen(),
          ),
          redirect: (BuildContext context, GoRouterState state) {
            if (!RoleManager.hasPermission(userRole, Permission.clientHome)) {
              return AppRoutes.unauthorizedScreen;
            }
            return null;
          }

        ),
        GoRoute(
          path: AppRoutes.clientRfqs,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MyRfq(),
          ),
          redirect: (BuildContext context, GoRouterState state) {
            if (!RoleManager.hasPermission(userRole, Permission.clientRfq)) {
              return AppRoutes.unauthorizedScreen;
            }
            return null;
          },
        ),
        GoRoute(
          path: AppRoutes.clientAddRequest,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ClientAddRequest(),
          ),
          redirect: (BuildContext context, GoRouterState state) {
            if (!RoleManager.hasPermission(userRole, Permission.clientCreateRequest)) {
              return AppRoutes.unauthorizedScreen;
            }
            return null;
          },
        ),
        GoRoute(
          path: AppRoutes.clientOngoingBids,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ClientOngoingBids(),
          ),
          redirect: (BuildContext context, GoRouterState state) {
            if (!RoleManager.hasPermission(userRole, Permission.clientBids)) {
              return AppRoutes.unauthorizedScreen;
            }
            return null;
          },
        ),
        GoRoute(
          path: AppRoutes.clientProfile,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ClientProfile(),
          ),
          redirect: (BuildContext context, GoRouterState state) {
            if (!RoleManager.hasPermission(userRole, Permission.clientProfile)) {
              return AppRoutes.unauthorizedScreen;
            }
            return null;
          },
        ),
      ],
    ),

    ShellRoute(
      builder: (context, state, child) => VendorBottomNavbarWrapper(
          child: child),
      routes: [
        GoRoute(
            path: AppRoutes.vendorHome,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: VendorHome(),
            ),
            redirect: (BuildContext context, GoRouterState state) {
              if (!RoleManager.hasPermission(userRole, Permission.vendorHome)) {
                return AppRoutes.unauthorizedScreen;
              }
              return null;
            }

        ),
        GoRoute(
          path: AppRoutes.vendorAvailableRfqs,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MyRfq(),
          ),
          redirect: (BuildContext context, GoRouterState state) {
            if (!RoleManager.hasPermission(userRole, Permission.clientRfq)) {
              return AppRoutes.unauthorizedScreen;
            }
            return null;
          },
        ),
        GoRoute(
          path: AppRoutes.vendorBids,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ClientAddRequest(),
          ),
          redirect: (BuildContext context, GoRouterState state) {
            if (!RoleManager.hasPermission(userRole, Permission.clientCreateRequest)) {
              return AppRoutes.unauthorizedScreen;
            }
            return null;
          },
        ),
        GoRoute(
          path: AppRoutes.vendorProfile,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ClientProfile(),
          ),
          redirect: (BuildContext context, GoRouterState state) {
            if (!RoleManager.hasPermission(userRole, Permission.clientProfile)) {
              return AppRoutes.unauthorizedScreen;
            }
            return null;
          },
        ),
      ],
    ),

    GoRoute(
      path: AppRoutes.unauthorizedScreen,
      builder: (context, state) => const UnauthorizedScreen(),
    ),
  ],
);
