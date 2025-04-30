import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:quickdeal/common/widget/custom_appbar.dart';
import '../../../../../core/services/routes/app_routes.dart';
import '../../../../../core/utils/constants/color_palette.dart';
import '../../../../../core/utils/helpers/helpers.dart';
import '../../../../../main.dart';
import '../widgets/client_view_rfq_card.dart';

class ClientViewOwnRfqScreen extends StatefulWidget {
  const ClientViewOwnRfqScreen({super.key});

  @override
  State<ClientViewOwnRfqScreen> createState() => _ClientViewOwnRfqScreenState();
}
class _ClientViewOwnRfqScreenState extends State<ClientViewOwnRfqScreen> {
  final clientId = supabase.auth.currentUser?.id;

  bool _isLoading = true;
  List<Map<String, dynamic>> _rfqs = [];
  List<Map<String, dynamic>> _filteredRfqs = [];
  Timer? _timer;

  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _fetchRfqs();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      setState(() {});
    });
  }

  void _applyFilter(String status) {
    setState(() {
      _selectedFilter = status;
      if (status == 'All') {
        _filteredRfqs = [..._rfqs];
      } else {
        _filteredRfqs =
            _rfqs.where((rfq) => rfq['rfq_status'] == status.toLowerCase()).toList();
      }
    });
  }

  Future<void> _fetchRfqs() async {
    try {
      final response = await supabase
          .from('rfqs')
          .select('*')
          .eq('client_id', clientId as Object);

      final List data = response as List;

      final filteredRfqs = data.where((rfq) {
        final bidCount = rfq['bids'] != null && rfq['bids'][0]['count'] != null
            ? rfq['bids'][0]['count']
            : 0;
        return bidCount == 0;
      }).toList();

      setState(() {
        _rfqs = filteredRfqs.cast<Map<String, dynamic>>();
        _applyFilter(_selectedFilter);
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _isLoading
          ? Center(child: AppHelperFunctions.appLoader(context))
          : _rfqs.isEmpty
          ? const Center(child: Text('All your RFQs have bids already!'))
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Filter chips
          Wrap(
            spacing: 8,
            children: ['All', 'Ongoing', 'Paused']
                .map((label) => FilterChip(
              label: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: _selectedFilter == label ? Colors.white : Colors
                      .grey,
                ),
              ),
              selected: _selectedFilter == label,
              onSelected: (_) => _applyFilter(label),
              selectedColor: AppColors.primaryAccent,
              backgroundColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(
                  color: _selectedFilter == label
                      ? Colors.white
                      : Colors.grey, // Border color when not selected
                  width: 0.5, // Border width
                ),
              ),
              checkmarkColor: Colors.white,
            ))
                .toList(),
          ),


          const SizedBox(height: 16),

          // RFQ cards
          ..._filteredRfqs.map((rfq) {
            return ClientOwnRfqCard(
              title: rfq['title'] ?? 'Untitled RFQ',
              status: rfq['rfq_status'] ?? 'active',
              description: rfq['description'] ?? 'No description available',
              budget: (rfq['budget'] ?? '0').toString(),
              biddingDeadline: rfq['bidding_deadline'],
              onTap: () {
                context.push(
                  AppRoutes.clientViewOwnRfqDetails.replaceFirst(
                    ':rfqTitle',
                    rfq['title'] ?? 'Untitled RFQ',
                  ),
                  extra: rfq,
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
