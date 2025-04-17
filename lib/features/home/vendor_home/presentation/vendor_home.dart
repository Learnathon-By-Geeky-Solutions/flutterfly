import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../common/widget/custom_appbar.dart';
import '../widgets/available_rfq_section.dart';
import '../widgets/home_section.dart';
import '../widgets/ongoing_bids_section.dart';

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  VendorHomeScreenState createState() => VendorHomeScreenState();
}

class VendorHomeScreenState extends State<VendorHomeScreen> {
  String? fullName;

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  void _loadName() {
    final user = Supabase.instance.client.auth.currentUser;
    setState(() {
      fullName = user?.userMetadata?['full_name'] ?? 'Guest';
    });
  }


  @override
  Widget build(BuildContext context) {
    // Sample data
    final List<RfqItem> availableRfqs = [
      const RfqItem(
        title: 'Ergonomic Office Chair',
        category: 'Office Furniture',
        description: 'Premium mesh back office chair with lumbar...',
        tags: ['Faster Delivery'],
        daysLeft: 15,
        priceRange: '\$5,000-\$8,000',
        isNew: true,
      ),
      const RfqItem(
        title: 'Website Redesign',
        category: 'Corporate website with CMS',
        tags: [],
        daysLeft: 10,
        priceRange: '\$3,000-\$5,000',
        isNew: true,
      ),
    ];

    final List<BidItem> ongoingBids = [
      const BidItem(
        title: 'UI/UX Design',
        clientName: 'Digital Solutions Inc.',
        bidAmount: 4500,
        daysLeft: 2,
        status: 'In Review',
      ),
    ];

    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Home section with welcome message and stats
              HomeSection(
                companyName: fullName ?? 'Guest',
                newRfqCount: 3,
                availableRfqCount: 12,
                ongoingBidsCount: 5,
                confirmedCount: 8,
                pendingAmount: 2.4,
              ),

              // Available RFQs section
              AvailableRfqSection(
                rfqItems: availableRfqs,
                onViewDetails: (item) {
                  // Handle view details action
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Viewing details for ${item.title}')),
                  );
                },
                onPlaceBid: (item) {
                  // Handle place bid action
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Placing bid for ${item.title}')),
                  );
                },
              ),

              // Ongoing Bids section
              OngoingBidsSection(
                bidItems: ongoingBids,
                onBidTap: (item) {
                  // Handle bid tap action
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Viewing bid for ${item.title}')),
                  );
                },
              ),

              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }
}