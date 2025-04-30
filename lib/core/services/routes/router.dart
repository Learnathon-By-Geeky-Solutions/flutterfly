import 'package:go_router/go_router.dart';
import 'auth_routes.dart';
import 'client_routes.dart';
import 'vendor_routes.dart';
import 'common_routes.dart';
import 'app_routes.dart';

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.authGate,
  routes: [
    ...authRoutes,
    clientShellRoute,
    vendorShellRoute,
    ...commonRoutes,
  ],
);