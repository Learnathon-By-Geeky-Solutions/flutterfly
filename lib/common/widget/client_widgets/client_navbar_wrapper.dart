import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/routes/app_routes.dart';
import 'client_bottom_navbar.dart';


class ClientBottomNavBarWrapper extends StatelessWidget {
  final Widget child;
  const ClientBottomNavBarWrapper({super.key, required this.child});

  static const List<String> _routes = [
    AppRoutes.clientHome,
    AppRoutes.clientRfqs,
    AppRoutes.clientAddRequest,
    AppRoutes.clientOngoingBids,
    AppRoutes.clientProfile
  ];

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return _routes.indexWhere((r) => location.startsWith(r));
  }

  void _onItemTapped(BuildContext context, int index) {
    context.go(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    return ClientBottomNavBar(
      selectedIndex: selectedIndex,
      onItemTapped: (index) => _onItemTapped(context, index),
      child: child,
    );
  }
}
