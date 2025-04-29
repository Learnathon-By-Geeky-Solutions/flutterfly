import 'package:go_router/go_router.dart';
import 'package:quickdeal/features/unauthorized/unauthorized_screen.dart';
import 'app_routes.dart';

final List<GoRoute> commonRoutes = [
  GoRoute(
    path: AppRoutes.unauthorizedScreen,
    builder: (context, state) => const UnauthorizedScreen(),
  ),
];
