import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickdeal/common/widget/custom_appbar.dart';
import '../../../core/utils/constants/color_palette.dart';
import '../../../main.dart';

class RfqBidsScreen extends StatefulWidget {
  final String rfqId;

  const RfqBidsScreen({super.key, required this.rfqId});

  @override
  State<RfqBidsScreen> createState() => _RfqBidsScreenState();
}

class _RfqBidsScreenState extends State<RfqBidsScreen> {
  List<Map<String, dynamic>> _allBids = [];
  Map<String, dynamic>? _currentlySelectedBid;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBids();
  }

  Future<void> _fetchBids() async {
    try {
      final response = await supabase
          .from('rfqs')
          .select('rfq_id, title, bids!bids_rfq_id_fkey(*, vendors(*)), rfqs_currently_selected_bid_id_fkey(*, vendors(*))')
          .eq('rfq_id', widget.rfqId)
          .single();

      final rfq = Map<String, dynamic>.from(response);
      final bids = List<Map<String, dynamic>>.from(rfq['bids'] ?? []);
      final selectedBid = rfq['rfqs_currently_selected_bid_id_fkey'];

      setState(() {
        _currentlySelectedBid = selectedBid != null ? Map<String, dynamic>.from(selectedBid) : null;
        _allBids = bids.where((bid) => selectedBid == null || bid['bid_id'] != selectedBid['bid_id']).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching bids: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: AppColors.scaffoldLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    if (_currentlySelectedBid != null) ...[
                      _buildBidCard(_currentlySelectedBid!, isSelected: true),
                      const SizedBox(height: 16),
                    ],
                    ..._allBids.map((bid) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildBidCard(bid),
                    )),
                    _buildViewAllButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Received Bids (${_allBids.length + (_currentlySelectedBid != null ? 1 : 0)})',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        TextButton.icon(
          onPressed: () {},
          icon: const Text(
            'Sort by',
            style: TextStyle(
              fontSize: 10,
              color: Colors.black54,
            ),
          ),
          label: const Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildBidCard(Map<String, dynamic> bid, {bool isSelected = false}) {
    final vendor = bid['vendors'] ?? {};
    final name = vendor['full_name'] ?? 'Vendor';
    final avatarText = name.isNotEmpty ? name[0] : 'V';
    final price = bid['proposed_price_per_item'] ?? 0.0;
    final delivery = bid['proposed_delivery_deadline'];
    final deliveryDate = delivery != null ? DateFormat('MMM d, yyyy').format(DateTime.parse(delivery)) : 'Unknown';
    final description = bid['proposal_details'] ?? '';
    final rating = vendor['rating'] ?? 0.0;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade200,
            width: isSelected ? 2 : 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  radius: 20,
                  child: Text(
                    avatarText,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          ...List.generate(
                            5,
                                (index) => Icon(
                              index < rating.floor()
                                  ? Icons.star
                                  : (index == rating.floor() && rating % 1 > 0)
                                  ? Icons.star_half
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.local_shipping_outlined,
                            size: 16,
                            color: Colors.black54,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'Delivery by $deliveryDate',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 75,
                  child: Text(
                    '৳${price.toStringAsFixed(2)}',
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            if (!isSelected)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final selectedBidId = bid['bid_id'];

                      await supabase
                          .from('rfqs')
                          .update({'currently_selected_bid_id': selectedBidId})
                          .eq('rfq_id', widget.rfqId);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Bid selected successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }

                      await _fetchBids();
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to select bid.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Select Bid',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            if (isSelected) ...[
              const SizedBox(height: 12),
              Row(
                children: const [
                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Selected',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showConfirmDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Confirm this bid',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Bid'),
        content: const Text('Are you sure you want to confirm this bid?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bid confirmed!'),
                  backgroundColor: Colors.blue,
                ),
              );
              // TODO: add backend confirmation logic if needed
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Widget _buildViewAllButton() {
    return Center(
      child: TextButton.icon(
        onPressed: () {},
        icon: const Text(
          'View All Bids',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 16,
          ),
        ),
        label: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.blue,
          size: 18,
        ),
      ),
    );
  }
}
