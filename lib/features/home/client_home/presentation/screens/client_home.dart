import 'package:flutter/material.dart';
import 'package:quickdeal/common/widget/custom_appbar.dart';
import 'package:quickdeal/core/utils/constants/color_palette.dart';
import 'package:quickdeal/features/home/client_home/presentation/widgets/active_rfq_card.dart';
import 'package:quickdeal/features/home/client_home/presentation/widgets/home_card.dart';
import 'package:quickdeal/features/home/client_home/presentation/widgets/recent_update.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  _ClientHomeScreenState createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
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
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display email or fallback message if it's not yet loaded
                  Text(
                    'Hello, $fullName!',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Ready to find a vendor?',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Submit New Request',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    children: const [
                      HomeCard(
                        icon: Icons.description,
                        iconColor: Colors.blue,
                        iconBackgroundColor: Colors.blue,
                        title: 'Total RFQs',
                        count: '12',
                      ),
                      HomeCard(
                        icon: Icons.access_time,
                        iconColor: Colors.orange,
                        iconBackgroundColor: Colors.orange,
                        title: 'Ongoing Bids',
                        count: '5',
                      ),
                      HomeCard(
                        icon: Icons.check_circle,
                        iconColor: Colors.green,
                        iconBackgroundColor: Colors.green,
                        title: 'Confirmed',
                        count: '3',
                      ),
                      HomeCard(
                        icon: Icons.pending_actions,
                        iconColor: Colors.red,
                        iconBackgroundColor: Colors.red,
                        title: 'Pending',
                        count: '2',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Active RFQs Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Active RFQs',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ActiveRfqCard(
                    title: 'Custom Website Development',
                    description: 'WordPress-based e-commerce website with custom features',
                    status: 'Bidding',
                    statusColor: Colors.blue,
                    statusBackgroundColor: Colors.blue.withOpacity(0.1),
                    currentBid: '2,500',
                  ),
                  ActiveRfqCard(
                    title: 'Logo Design Package',
                    description: 'Modern logo design with brand guidelines',
                    status: 'Pending',
                    statusColor: Colors.orange,
                    statusBackgroundColor: Colors.orange.withOpacity(0.1),
                    budget: '500',
                  ),
                ],
              ),
            ),
            // Recent Updates Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recent Updates',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  RecentUpdate(
                    icon: Icons.info,
                    iconColor: Colors.white,
                    iconBackgroundColor: Colors.blue,
                    message: 'DesignPro placed a bid on your website project',
                  ),
                  RecentUpdate(
                    icon: Icons.check,
                    iconColor: Colors.white,
                    iconBackgroundColor: Colors.green,
                    message: 'Logo project is awaiting your confirmation',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}