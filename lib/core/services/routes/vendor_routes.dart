import 'package:go_router/go_router.dart';
import 'package:quickdeal/features/home/vendor_home/presentation/vendor_home.dart';
import 'package:quickdeal/features/profile/vendor_profile/vendor_profile.dart';
import 'package:quickdeal/features/bidding/vendor_bidding/presentation/screens/vendor_bidding.dart';
import 'package:quickdeal/features/rfq/vendor_rfq/vendor_rfq.dart';
import 'package:quickdeal/features/rfq/vendor_rfq/view_rfq_details/presentation/view_rfq_details.dart';
import 'package:quickdeal/features/bidding/vendor_bidding/vendor_view_bids/presentation/vendor_view_own_bid_details.dart';
import '../../../common/widget/vendor_widgets/vendor_navbar_wrapper.dart';
import '../role_manager/role_manager.dart';
import 'app_routes.dart';

final ShellRoute vendorShellRoute = ShellRoute(
  builder: (context, state, child) => VendorBottomNavbarWrapper(child: child),
  routes: [
    GoRoute(
      path: AppRoutes.vendorHome,
      pageBuilder: (context, state) => const NoTransitionPage(child: VendorHomeScreen()),
      redirect: (context, state) =>
      RoleManager.hasPermission(getCurrentUserRole(), Permission.vendorHome)
          ? null
          : AppRoutes.unauthorizedScreen,
    ),
    GoRoute(
      path: AppRoutes.vendorAvailableRfqs,
      pageBuilder: (context, state) => const NoTransitionPage(child: VendorRfq()),
      redirect: (context, state) =>
      RoleManager.hasPermission(getCurrentUserRole(), Permission.vendorRfq)
          ? null
          : AppRoutes.unauthorizedScreen,
    ),
    GoRoute(
      path: AppRoutes.vendorBids,
      pageBuilder: (context, state) => const NoTransitionPage(child: VendorBidding()),
      redirect: (context, state) =>
      RoleManager.hasPermission(getCurrentUserRole(), Permission.vendorBids)
          ? null
          : AppRoutes.unauthorizedScreen,
    ),
    GoRoute(
      path: AppRoutes.vendorProfile,
      pageBuilder: (context, state) => const NoTransitionPage(child: VendorProfile()),
      redirect: (context, state) =>
      RoleManager.hasPermission(getCurrentUserRole(), Permission.vendorProfile)
          ? null
          : AppRoutes.unauthorizedScreen,
    ),
    GoRoute(
      path: AppRoutes.vendorViewRfqDetailsScreen,
      pageBuilder: (context, state) {
        final rfq = state.extra as Map<String, dynamic>;
        return NoTransitionPage(child: RfqDetailsPage(rfq: rfq));
      },
      redirect: (context, state) =>
      RoleManager.hasPermission(getCurrentUserRole(), Permission.vendorRfq)
          ? null
          : AppRoutes.unauthorizedScreen,
    ),
    GoRoute(
      path: AppRoutes.vendorViewOwnBidDetails,
      pageBuilder: (context, state) {
        // Access extra data passed during navigation
        final extra = state.extra as Map<String, dynamic>?;
        final bidId = extra?['bid_id'] ?? '';  // Match the key 'bid_id' here
        final rfqId = extra?['rfq_id'] ?? '';  // Match the key 'rfq_id' here

        return NoTransitionPage(
          child: VendorViewOwnBidDetails(
            bidId: bidId,
            rfqId: rfqId,
          ),
        );
      },
      redirect: (context, state) {
        return RoleManager.hasPermission(getCurrentUserRole(), Permission.vendorBids)
            ? null
            : AppRoutes.unauthorizedScreen;
      },
    )


  ],
);
