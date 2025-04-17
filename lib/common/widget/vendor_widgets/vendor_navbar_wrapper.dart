import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickdeal/common/widget/vendor_widgets/vendor_navbar.dart';
import '../../../core/services/routes/app_routes.dart';

class VendorBottomNavbarWrapper extends StatelessWidget {
  final Widget child;
  const VendorBottomNavbarWrapper({super.key, required this.child});

  static const List<String> _routes = [
    AppRoutes.vendorHome,
    AppRoutes.vendorAvailableRfqs,
    AppRoutes.vendorBids,
    AppRoutes.vendorProfile,
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
    return VendorBottomNavBar(
      selectedIndex: selectedIndex,
      onItemTapped: (index) => _onItemTapped(context, index),
      child: child,
    );
  }
}
