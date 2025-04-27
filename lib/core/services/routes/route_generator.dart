import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickdeal/features/auth/auth_gate.dart';
import 'package:quickdeal/features/auth/login/presentation/screens/login_screen.dart';
import 'package:quickdeal/features/auth/signup/client_signup/presentation/screens/client_signup_screen.dart';
import 'package:quickdeal/features/auth/otp_screen/email_otp_screen.dart';
import 'package:quickdeal/features/auth/signup/vendor_signup/presentation/screens/vendor_signup_business_info_screen.dart';
import 'package:quickdeal/features/bidding/vendor_bidding/presentation/screens/vendor_bidding.dart';
import 'package:quickdeal/features/home/client_home/presentation/screens/client_home.dart';
import 'package:quickdeal/features/bidding/client_bidding/client_ongoing_bids.dart';
import 'package:quickdeal/features/profile/client_profile/client_profile.dart';
import 'package:quickdeal/features/profile/vendor_profile/vendor_profile.dart';
import 'package:quickdeal/features/splash/presentation/splash_screen.dart';
import '../../../common/widget/client_widgets/client_navbar_wrapper.dart';
import '../../../common/widget/vendor_widgets/vendor_navbar_wrapper.dart';
import '../../../features/auth/signup/vendor_signup/presentation/screens/vendor_signup_services_screen.dart';
import '../../../features/home/vendor_home/presentation/vendor_home.dart';
import '../../../features/rfq/client_rfq/presentation/screens/client_add_request_screen.dart';
import '../../../features/rfq/vendor_rfq/vendor_rfq.dart';
import '../../../features/unauthorized/unauthorized_screen.dart';
import '../role_manager/role_manager.dart';
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
      ShellRoute(
        builder: (context, state, child) => ClientBottomNavBarWrapper(child: child),
        routes: [
          GoRoute(
              path: AppRoutes.clientHome,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ClientHomeScreen(),
              ),
              redirect: (BuildContext context, GoRouterState state) {
                final userRole = getCurrentUserRole();
                if (!RoleManager.hasPermission(userRole, Permission.clientHome)) {
                  return AppRoutes.unauthorizedScreen;
                }
                return null;
              }

          ),
          GoRoute(
            path: AppRoutes.clientRfqs,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ClientAddRequestScreen(),
            ),
            redirect: (BuildContext context, GoRouterState state) {
              final userRole = getCurrentUserRole();
              if (!RoleManager.hasPermission(userRole, Permission.clientRfq)) {
                return AppRoutes.unauthorizedScreen;
              }
              return null;
            },
          ),
          GoRoute(
            path: AppRoutes.clientAddRequest,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ClientAddRequestScreen(),
            ),
            redirect: (BuildContext context, GoRouterState state) {
              final userRole = getCurrentUserRole();
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
              final userRole = getCurrentUserRole();
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
              final userRole = getCurrentUserRole();
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
                child: VendorHomeScreen(),
              ),
              redirect: (BuildContext context, GoRouterState state) {
                final userRole = getCurrentUserRole();
                if (!RoleManager.hasPermission(userRole, Permission.vendorHome)) {
                  return AppRoutes.unauthorizedScreen;
                }
                return null;
              }

          ),
          GoRoute(
            path: AppRoutes.vendorAvailableRfqs,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: VendorRfq(),
            ),
            redirect: (BuildContext context, GoRouterState state) {
              final userRole = getCurrentUserRole();
              if (!RoleManager.hasPermission(userRole, Permission.vendorRfq)) {
                return AppRoutes.unauthorizedScreen;
              }
              return null;
            },
          ),
          GoRoute(
            path: AppRoutes.vendorBids,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: VendorBidding(),
            ),
            redirect: (BuildContext context, GoRouterState state) {
              final userRole = getCurrentUserRole();
              if (!RoleManager.hasPermission(userRole, Permission.vendorBids)) {
                return AppRoutes.unauthorizedScreen;
              }
              return null;
            },
          ),
          GoRoute(
            path: AppRoutes.vendorProfile,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: VendorProfile(),
            ),
            redirect: (BuildContext context, GoRouterState state) {
              final userRole = getCurrentUserRole();
              if (!RoleManager.hasPermission(userRole, Permission.vendorProfile)) {
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



