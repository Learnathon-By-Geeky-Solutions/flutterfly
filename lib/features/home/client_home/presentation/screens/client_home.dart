import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickdeal/common/widget/custom_appbar.dart';
import 'package:quickdeal/core/utils/constants/color_palette.dart';
import 'package:quickdeal/features/home/client_home/presentation/widgets/active_rfq_card.dart';
import 'package:quickdeal/features/home/client_home/presentation/widgets/home_card.dart';
import 'package:quickdeal/features/home/client_home/presentation/widgets/recent_update.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/services/routes/app_routes.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  _ClientHomeScreenState createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  String? fullName;
  List<Map<String, dynamic>> _activeRfqs = [];
  List<Map<String, dynamic>> _recentUpdates = [];
  bool _isLoading = true;

  int totalRfqs = 0;
  int ongoingBids = 0;
  int confirmed = 0;
  int pending = 0;

  @override
  void initState() {
    super.initState();
    _loadName();
    _fetchActiveRfqs();
    _fetchRecentUpdates();
    _fetchRFQStats();
  }

  // Load client's full name
  void _loadName() {
    final user = Supabase.instance.client.auth.currentUser;
    setState(() {
      fullName = user?.userMetadata?['full_name'] ?? 'Guest';
    });
  }

  // Fetch Active RFQs from the Supabase database
  Future<void> _fetchActiveRfqs() async {
    try {
      final clientId = Supabase.instance.client.auth.currentUser?.id;
      final response = await Supabase.instance.client
          .from('rfqs')
          .select('*')
          .eq('client_id', clientId as Object)
          .eq('rfq_status', 'ongoing')
          .order('created_at', ascending: false);

      final List data = response;
      setState(() {
        _activeRfqs = data.cast<Map<String, dynamic>>();
      });
    } catch (error) {
      print('Error fetching active RFQs: $error');
    }
  }

  // Fetch Recent Updates
  Future<void> _fetchRecentUpdates() async {
    try {
      final clientId = Supabase.instance.client.auth.currentUser?.id;
      final response = await Supabase.instance.client
          .from('notifications')
          .select('*')
          .eq('client_id', clientId as Object)
          .order('created_at', ascending: false);

      final List data = response;
      setState(() {
        _recentUpdates = data.cast<Map<String, dynamic>>();
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching recent updates: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fetch RFQ stats like total RFQs, ongoing, confirmed, and pending
  Future<void> _fetchRFQStats() async {
    try {
      final clientId = Supabase.instance.client.auth.currentUser?.id;

      // Fetch total RFQs
      final totalResponse = await Supabase.instance.client
          .from('rfqs')
          .select('*')
          .eq('client_id', clientId as Object);
      setState(() {
        totalRfqs = totalResponse.length;
      });

      // Fetch ongoing RFQs
      final ongoingResponse = await Supabase.instance.client
          .from('rfqs')
          .select('*')
          .eq('client_id', clientId as Object)
          .eq('rfq_status', 'ongoing');
      setState(() {
        ongoingBids = ongoingResponse.length;
      });

      // Fetch confirmed RFQs
      final confirmedResponse = await Supabase.instance.client
          .from('rfqs')
          .select('*')
          .eq('client_id', clientId as Object)
          .eq('rfq_status', 'closed');
      setState(() {
        confirmed = confirmedResponse.length;
      });

      // Fetch pending RFQs
      final pendingResponse = await Supabase.instance.client
          .from('rfqs')
          .select('*')
          .eq('client_id', clientId as Object)
          .eq('rfq_status', 'paused');
      setState(() {
        pending = pendingResponse.length;
      });
    } catch (error) {
      print('Error fetching RFQ stats: $error');
    }
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
                      onPressed: () {
                        // Navigate to submit new request
                        context.go(AppRoutes.clientAddRequest);
                      },
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
                    children: [
                      HomeCard(
                        icon: Icons.description,
                        iconColor: Colors.blue,
                        iconBackgroundColor: Colors.blue,
                        title: 'Total RFQs',
                        count: totalRfqs.toString(),
                      ),
                      HomeCard(
                        icon: Icons.access_time,
                        iconColor: Colors.orange,
                        iconBackgroundColor: Colors.orange,
                        title: 'Active',
                        count: ongoingBids.toString(),
                      ),
                      HomeCard(
                        icon: Icons.check_circle,
                        iconColor: Colors.green,
                        iconBackgroundColor: Colors.green,
                        title: 'Confirmed',
                        count: confirmed.toString(),
                      ),
                      HomeCard(
                        icon: Icons.pending_actions,
                        iconColor: Colors.red,
                        iconBackgroundColor: Colors.red,
                        title: 'Paused',
                        count: pending.toString(),
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
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _activeRfqs.isEmpty
                      ? const Center(child: Text('No active RFQs.'))
                      : Column(
                    children: _activeRfqs.map((rfq) {
                      return ActiveRfqCard(
                        title: rfq['title'],
                        description: rfq['description'],
                        status: rfq['rfq_status'],
                        statusColor: Colors.blue,
                        statusBackgroundColor: Colors.blue.withOpacity(0.1),
                        currentBid: rfq['current_bid'] ?? 'N/A',
                      );
                    }).toList(),
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
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _recentUpdates.isEmpty
                      ? const Center(child: Text('No recent updates.'))
                      : Column(
                    children: _recentUpdates.map((update) {
                      return RecentUpdate(
                        icon: Icons.info,
                        iconColor: Colors.white,
                        iconBackgroundColor: Colors.blue,
                        message: update['message'],
                      );
                    }).toList(),
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
