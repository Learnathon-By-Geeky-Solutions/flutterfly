import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:quickdeal/common/widget/custom_appbar.dart';
import 'package:quickdeal/core/utils/constants/color_palette.dart';
import '../../../../../main.dart';
import '../../../../core/services/routes/app_routes.dart';

class VendorPlaceBid extends StatefulWidget {
  final Map<String, dynamic> rfq;

  const VendorPlaceBid({super.key, required this.rfq});

  @override
  State<VendorPlaceBid> createState() => _PlaceBidPageState();
}

class _PlaceBidPageState extends State<VendorPlaceBid> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _proposalDetailsController = TextEditingController();
  final TextEditingController _submissionDateController = TextEditingController();

  final String? userId = supabase.auth.currentUser?.id;

  double? get _totalAmount {
    final quantity = widget.rfq['quantity'];
    final price = double.tryParse(_amountController.text);
    if (quantity is num && price != null) {
      return quantity * price;
    }
    return null;
  }

  Future<void> _submitBid() async {
    if (!_formKey.currentState!.validate()) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Submission"),
        content: const Text(
          "Are you sure you want to submit this bid? You cannot edit it after submission.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Submit"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final insertedBid = {
        'rfq_id': widget.rfq['rfq_id'],
        'vendor_id': userId,
        'proposed_price_per_item': double.parse(_amountController.text),
        'proposal_details': _proposalDetailsController.text,
        'proposed_delivery_deadline': DateFormat('dd-MM-yyyy')
            .parse(_submissionDateController.text)
            .toIso8601String(),
      };

      await supabase.from('bids').insert(insertedBid);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Bid placed successfully!'),
            backgroundColor: Colors.green,
        ),
      );

       context.go(AppRoutes.vendorBids);

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place bid: $e')),
      );
    }
  }


  @override
  void initState() {
    super.initState();
    _amountController.addListener(() {
      setState(() {}); // Trigger rebuild to show total amount
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _proposalDetailsController.dispose();
    _submissionDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  "Place your offer for ${widget.rfq['title'] ?? 'RFQ'}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Info Text
                Text(
                  "After submission of the bid, you cannot edit it. You can only withdraw the bid.",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 24),

                // Amount Section
                const Text(
                  "Proposed Price per Unit (BDT)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Enter amount',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Amount is required';
                    final parsed = double.tryParse(value);
                    if (parsed == null || parsed <= 0) return 'Enter a valid amount';
                    return null;
                  },
                ),
                if (_totalAmount != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Total Price: ${widget.rfq['quantity']} × '
                          '${_amountController.text} = ৳${_totalAmount!.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),

                // Proposal Details Section
                const Text(
                  "Proposal Details (Optional)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _proposalDetailsController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Enter proposal description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                // Submission Date Section
                const Text(
                  "Proposed Delivery Deadline",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _submissionDateController,
                  readOnly: true,
                  onTap: () async {
                    final rfqDeadline = DateTime.tryParse(widget.rfq['delivery_deadline']);
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: rfqDeadline ?? DateTime(2101),
                    );
                    if (picked != null) {
                      if (rfqDeadline != null && picked.isAfter(rfqDeadline)) {
                        if(!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Selected date exceeds RFQ delivery deadline (${DateFormat('dd-MM-yyyy').format(rfqDeadline)}).'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }
                      _submissionDateController.text = DateFormat('dd-MM-yyyy').format(picked);
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Select deadline',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a date';
                    }
                    final selected = DateFormat('dd-MM-yyyy').parse(value);
                    final rfqDeadline = DateTime.tryParse(widget.rfq['delivery_deadline']);
                    if (rfqDeadline != null && selected.isAfter(rfqDeadline)) {
                      return 'Deadline must be on or before ${DateFormat('dd-MM-yyyy').format(rfqDeadline)}';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                Center(
                  child: ElevatedButton(
                    onPressed: _submitBid,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Submit Bid', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
