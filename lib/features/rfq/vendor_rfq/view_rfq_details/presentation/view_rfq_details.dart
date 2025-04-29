import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickdeal/common/widget/custom_appbar.dart';
import '../../../../../core/utils/constants/color_palette.dart';
import '../../../../../main.dart';

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

      if (response != null) {
        setState(() {
          _myBids.add(response); // Optimistically add bid
        });

        _amountController.clear();
        _proposalDetailsController.clear();
        _submissionDateController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bid placed successfully!')),
        );
      }
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
            const SizedBox(height: 8),
            _buildBidAndDeliveryInfo(),
            const SizedBox(height: 16),
            _buildSpecificationsSection(),
            const SizedBox(height: 16),
            _buildClientRequestDetails(),
            const SizedBox(height: 16),
            _buildClientInfo(),
            const SizedBox(height: 16),
            _buildMyBidsSection(), // 👉 your new section
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: _buildPlaceBidButton(),
    );
  }

  // --- UI Widgets ---

  Widget _buildProductInfo() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.rfq['title'] ?? 'No Title',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight
                      .bold),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.rfq['description'] ?? 'No Description',
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                _buildCategoryAndDelivery(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryAndDelivery() {
    return Row(
      children: [
        _buildBadge(widget.rfq['category_id']?.toString() ?? 'No Category', Colors.grey[200]),
      ],
    );
  }

  Widget _buildBadge(String text, Color? color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          if (icon != null) Icon(icon, size: 12, color: Colors.red[400]),
          if (icon != null) const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(fontSize: 10, color: Colors.red[400]),
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
            const Text('Client Budget', style: TextStyle(color: Colors.white,
                fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              '\$${widget.rfq['min_budget'] ?? 0} - \$${widget.rfq['max_budget'] ?? 0}',
              style: const TextStyle(color: Colors.white, fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            const Text('Delivery Deadline', style: TextStyle(color: Colors
                .white, fontSize: 10)),
            const SizedBox(height: 4),
            Text(
              widget.rfq['delivery_deadline'] != null
                  ? DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.rfq['delivery_deadline']))
                  : 'No Date',
              style: const TextStyle(color: Colors.white, fontSize: 14,
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
          Text(widget.rfq['specification']?.join(', ') ?? 'Not Specified'),
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
          _buildDetailRow('Quantity Needed', widget.rfq['quantity']?.toString() ?? 'Not Available'),
          const Divider(height: 24),
          _buildDetailRow('Bidding Deadline', widget.rfq['bidding_deadline'] != null
              ? DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.rfq['bidding_deadline']))
              : 'Not Available'),
          const Divider(height: 24),
          _buildDetailRow('Location', widget.rfq['location'] ?? 'Not Available'),
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

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        Text(value, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
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
        onPressed: _showPlaceBidDialog,
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

  void _showPlaceBidDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Place Your Bid'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Proposed Amount per Unit'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _proposalDetailsController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Proposal Details'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _submissionDateController,
                      readOnly: true,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null) {
                          setState(() {
                            _submissionDateController.text = DateFormat('dd-MM-yyyy').format(picked);
                          });
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Project Submission Date'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _submitBid();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryAccent),
                  child: const Text('Place Bid'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildMyBidsSection() {
    if (_myBids.isEmpty) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('My Bids', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _myBids.length,
            itemBuilder: (context, index) {
              final bid = _myBids[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text('\$${bid['proposed_price_per_item'] ?? 'N/A'} per unit'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Delivery by: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(bid['proposed_delivery_deadline']))}'),
                      if (bid['proposal_details'] != null) Text('Details: ${bid['proposal_details']}'),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
