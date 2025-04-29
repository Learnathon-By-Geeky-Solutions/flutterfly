import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickdeal/common/widget/custom_appbar.dart';
import 'dart:async';
import '../../../core/services/routes/app_routes.dart';
import '../../../core/utils/helpers/helpers.dart';
import '../../../main.dart';

class ClientOngoingRfqsPage extends StatefulWidget {
  const ClientOngoingRfqsPage({super.key});

  @override
  _ClientOngoingRfqsPageState createState() => _ClientOngoingRfqsPageState();
}

class _ClientOngoingRfqsPageState extends State<ClientOngoingRfqsPage> {
  final clientId = supabase.auth.currentUser?.id;

  bool _isLoading = true;
  List<Map<String, dynamic>> _rfqs = [];
  Timer? _timer; // Add a timer

  @override
  void initState() {
    super.initState();
    _fetchRfqs();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // Just triggers a rebuild to update countdowns
      });
    });
  }

  Future<void> _fetchRfqs() async {
    try {
      final response = await supabase
          .from('rfqs')
          .select('rfq_id, title, bidding_deadline, bids!bids_rfq_id_fkey(count)')
          .eq('client_id', clientId as Object);

      final List data = response as List;

      setState(() {
        _rfqs = data.cast<Map<String, dynamic>>();
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching RFQs: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getTimeLeft(String deadline) {
    final endDate = DateTime.parse(deadline);
    final now = DateTime.now();
    final difference = endDate.difference(now);

    if (difference.isNegative) return 'Deadline Passed';

    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    return '${twoDigits(days)}:${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)} left till deadline';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: AppHelperFunctions.appLoader(context));
    }

    if (_rfqs.isEmpty) {
      return const Center(child: Text('No active RFQs'));
    }

    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _rfqs.length,
        itemBuilder: (context, index) {
          final rfq = _rfqs[index];

          final bidCount = rfq['bids'] != null && rfq['bids'][0]['count'] != null
              ? rfq['bids'][0]['count']
              : 0;

          return GestureDetector(
            onTap: () {
              context.push('${AppRoutes.clientRfqs}/${rfq['rfq_id']}/bids');
            },
            child: Card(
              elevation: 5,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rfq['title'] ?? 'Untitled RFQ',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.gavel, size: 18, color: Colors.blueGrey),
                        const SizedBox(width: 6),
                        Text('$bidCount Bids Submitted', style: const TextStyle(color: Colors.blueGrey)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, size: 18, color: Colors.redAccent),
                        const SizedBox(width: 6),
                        Text(
                          _getTimeLeft(rfq['bidding_deadline']),
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
