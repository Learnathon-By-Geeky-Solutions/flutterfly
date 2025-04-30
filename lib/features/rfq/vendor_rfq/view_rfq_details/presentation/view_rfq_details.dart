import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:quickdeal/common/widget/custom_appbar.dart';
import 'package:quickdeal/core/utils/helpers/helpers.dart';
import '../../../../../core/services/routes/app_routes.dart';
import '../../../../../core/utils/constants/color_palette.dart';
import '../../../../../main.dart';
import '../../../client_rfq/view_rfq/widgets/specification_card.dart';

class RfqDetailsPage extends StatefulWidget {
  final Map<String, dynamic> rfq;

  const RfqDetailsPage({super.key, required this.rfq});

  @override
  _RfqDetailsPageState createState() => _RfqDetailsPageState();
}

class _RfqDetailsPageState extends State<RfqDetailsPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _proposalDetailsController = TextEditingController();
  final TextEditingController _submissionDateController = TextEditingController();

  List<Map<String, dynamic>> _myBids = [];

  final String? userId = supabase.auth.currentUser?.id;

  @override
  void initState() {
    super.initState();
    _fetchMyBids();
  }

  Future<void> _fetchMyBids() async {
    if (userId == null) return;
    final response = await supabase
        .from('bids')
        .select()
        .eq('vendor_id', userId as Object)
        .eq('rfq_id', widget.rfq['rfq_id']);

    if (mounted) {
      setState(() {
        _myBids = List<Map<String, dynamic>>.from(response);
      });
    }
  }

  Future<void> _submitBid() async {
    try {
      final insertedBid = {
        'rfq_id': widget.rfq['rfq_id'],
        'vendor_id': userId,
        'proposed_price_per_item': double.parse(_amountController.text),
        'proposal_details': _proposalDetailsController.text,
        'proposed_delivery_deadline': DateFormat('dd-MM-yyyy').parse(_submissionDateController.text).toIso8601String(),
      };

      final response = await supabase.from('bids').insert(insertedBid).select().single();

      setState(() {
        _myBids.add(response);
      });

      _amountController.clear();
      _proposalDetailsController.clear();
      _submissionDateController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bid placed successfully!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place bid: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductInfo(),
            const SizedBox(height: 16),
            _buildBidAndDeliveryInfo(),
            const SizedBox(height: 16),
            _buildDescriptionSection(),
            const SizedBox(height: 16),
            _buildSpecificationsSection(),
            const SizedBox(height: 16),
            _buildClientRequestDetails(),
            const SizedBox(height: 16),
            _buildClientInfo(),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: _buildPlaceBidButton(),
    );
  }

  // --- UI Widgets ---
  Widget _buildDescriptionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            widget.rfq['description'] ?? 'No Description',
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.rfq['title'] ?? 'No Title',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            widget.rfq['description'] ?? 'No Description',
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          if (widget.rfq['category_names'] != null &&
              widget.rfq['category_names'].isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: widget.rfq['category_names']
                    .map<Widget>((category) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: AppColors.primaryAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBidAndDeliveryInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: Colors.white,
      child: Row(
        children: [
          _buildBidInfo(),
          const SizedBox(width: 12),
          _buildDeliveryInfo(),

        ],
      ),
    );
  }

  Widget _buildBidInfo() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            const Text('Client Budget', style: TextStyle(color: Colors.white, fontSize: 14)),
            const SizedBox(height: 4),
            Text(
                '${widget.rfq['budget'] ?? 0}৳',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18.5, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            const Text('Delivery Deadline', style: TextStyle(color: Colors
                .white, fontSize: 11)),
            const SizedBox(height: 7),
            Text(
              widget.rfq['delivery_deadline'] != null
                  ? AppHelperFunctions.formatDate(widget.rfq['delivery_deadline'])
                  : 'No Date',
              style: const TextStyle(color: Colors.white, fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecificationsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Specifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (widget.rfq['specification'] != null && widget.rfq['specification']!
              .isNotEmpty)
            ...widget.rfq['specification']!.map<Widget>((spec) {
              return SpecificationCard(
                title: spec['key'] ?? 'No title',
                value: spec['value'] ?? 'No value',
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildClientRequestDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Client Request Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // Card for Quantity Needed
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: const Text('Quantity Needed', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(widget.rfq['quantity']?.toString() ?? 'Not Available'),
            ),
          ),

          const SizedBox(height: 16),

          // Card for Bidding Deadline
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: const Text('Bidding Deadline', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(widget.rfq['bidding_deadline'] != null
                  ? DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.rfq['bidding_deadline']))
                  : 'Not Available'),
            ),
          ),

          const SizedBox(height: 16),

          // Card for Location
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: const Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(widget.rfq['location'] ?? 'Not Available'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientInfo() {
    final client = widget.rfq['clients'];

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: client != null && client['profile_pic'] != null
                ? NetworkImage(client['profile_pic'])
                : null,
            child: client == null || client['profile_pic'] == null
                ? const Icon(Icons.person, size: 30, color: Colors.grey)
                : null,
          ),
          const SizedBox(width: 16),
          Text(
            client != null ? client['full_name'] ?? 'No Name' : 'No Client Info',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceBidButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, -5)),
        ],
      ),
      child: ElevatedButton(
        onPressed: _navigateToPlaceBidPage,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Enter Your Offer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _navigateToPlaceBidPage() async {
    final success = await context.push<bool>(
    AppRoutes.vendorPlaceBid,
    extra: widget.rfq,
    );

    if (success == true) {
      _fetchMyBids();
    }
  }
}
