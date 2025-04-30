import 'package:go_router/go_router.dart';
import 'package:quickdeal/features/home/client_home/presentation/screens/client_home.dart';
import 'package:quickdeal/features/profile/client_profile/client_profile.dart';
import 'package:quickdeal/features/bidding/client_bidding/client_ongoing_bids.dart';
import 'package:quickdeal/features/bidding/client_bidding/rfq_bids_screen.dart';
import 'package:quickdeal/features/rfq/client_rfq/view_rfq/presentation/client_view_own_rfq.dart';
import '../../../common/widget/client_widgets/client_navbar_wrapper.dart';
import '../../../features/rfq/client_rfq/create_rfq/presentation/screens/client_add_request_screen.dart';
import '../../../features/rfq/client_rfq/view_rfq/presentation/client_view_rfq_details.dart';
import '../role_manager/role_manager.dart';
import 'app_routes.dart';

final ShellRoute clientShellRoute = ShellRoute(
  builder: (context, state, child) => ClientBottomNavBarWrapper(child: child),
  routes: [
    GoRoute(
      path: AppRoutes.clientHome,
      pageBuilder: (context, state) => const NoTransitionPage(child: ClientHomeScreen()),
      redirect: (context, state) =>
      RoleManager.hasPermission(getCurrentUserRole(), Permission.clientHome)
          ? null
          : AppRoutes.unauthorizedScreen,
    ),
    GoRoute(
      path: AppRoutes.clientRfqs,
      pageBuilder: (context, state) => const NoTransitionPage(child: ClientViewOwnRfqScreen()),
      redirect: (context, state) =>
      RoleManager.hasPermission(getCurrentUserRole(), Permission.clientRfq)
          ? null
          : AppRoutes.unauthorizedScreen,
    ),
    GoRoute(
      path: '${AppRoutes.clientRfqs}/:rfqId/bids',
      pageBuilder: (context, state) {
        final rfqId = state.pathParameters['rfqId']!;
        return NoTransitionPage(child: RfqBidsScreen(rfqId: rfqId));
      },
    ),
    GoRoute(
      path: AppRoutes.clientAddRequest,
      pageBuilder: (context, state) => const NoTransitionPage(child: ClientAddRequestScreen()),
      redirect: (context, state) =>
      RoleManager.hasPermission(getCurrentUserRole(), Permission.clientCreateRequest)
          ? null
          : AppRoutes.unauthorizedScreen,
    ),
    GoRoute(
      path: AppRoutes.clientOngoingBids,
      pageBuilder: (context, state) => const NoTransitionPage(child: ClientOngoingRfqsPage()),
      redirect: (context, state) =>
      RoleManager.hasPermission(getCurrentUserRole(), Permission.clientBids)
          ? null
          : AppRoutes.unauthorizedScreen,
    ),
    GoRoute(
      path: AppRoutes.clientProfile,
      pageBuilder: (context, state) => const NoTransitionPage(child: ClientProfile()),
      redirect: (context, state) =>
      RoleManager.hasPermission(getCurrentUserRole(), Permission.clientProfile)
          ? null
          : AppRoutes.unauthorizedScreen,
    ),
    GoRoute(
      path: AppRoutes.clientViewOwnRfqDetails,
      builder: (context, state) {
        final rfqData = state.extra as Map<String, dynamic>;
        return ClientViewOwnRfqDetailPage(rfqData: rfqData);
      },
    ),
  ],
);
