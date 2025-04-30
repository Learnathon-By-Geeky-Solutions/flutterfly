import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:quickdeal/core/utils/helpers/helpers.dart';
import '../../../../../common/widget/custom_appbar.dart';
import '../../../../../core/services/routes/app_routes.dart';
import '../../../../../core/utils/constants/color_palette.dart';
import '../../../../../main.dart';
import '../widgets/specification_card.dart';

class ClientViewOwnRfqDetailPage extends StatelessWidget {
  final Map<String, dynamic> rfqData;

  const ClientViewOwnRfqDetailPage({super.key, required this.rfqData});

  Future<void> _toggleRfqStatus(BuildContext context) async {
    final newStatus = rfqData['rfq_status'] == 'paused' ? 'ongoing' : 'paused';

    await supabase
        .from('rfqs')
        .update({'rfq_status': newStatus})
        .eq('rfq_id', rfqData['rfq_id']);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'RFQ has been ${newStatus == 'paused' ? 'paused' : 'enabled'}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: newStatus == 'paused' ? Colors.orange : Colors.green,
      ),
    );


    if(!context.mounted) return ;
    context.pushReplacement(
      AppRoutes.clientViewOwnRfqDetails.replaceFirst(
        ':rfqTitle',
        rfqData['title'] ?? 'Untitled RFQ',
      ),
      extra: {
        ...rfqData,
        'rfq_status': newStatus,
      },
    );


  }

  Future<void> _deleteRfq(BuildContext context) async {
    await supabase
        .from('rfqs')
        .delete()
        .eq('rfq_id', rfqData['rfq_id']);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('RFQ has been deleted')),
    );

    Navigator.pop(context); // Or navigate to listing/dashboard if needed
  }

  void _showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(title),
        content: Text(content),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 10),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5A7E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child: const Text('Confirm', style: TextStyle(fontSize: 10)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // RFQ Title and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    rfqData['title'] ?? 'Untitled RFQ',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: rfqData['rfq_status'] == 'paused'
                        ? Colors.orange.shade100
                        : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    rfqData['rfq_status'] == 'paused' ? 'Paused' : 'Active',
                    style: TextStyle(
                      color: rfqData['rfq_status'] == 'paused'
                          ? Colors.orange
                          : Colors.green,
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            if (rfqData['category_names'] != null &&
                rfqData['category_names'].isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: rfqData['category_names']
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

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Bidding ends on ${AppHelperFunctions.formatDate
                    (rfqData['bidding_deadline'])}',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estd. Budget',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${rfqData['budget']}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Delivery Deadline',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppHelperFunctions.formatDate
                          (rfqData['delivery_deadline']),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.production_quantity_limits, size: 20, color: AppColors.primaryAccent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quantity Needed',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              rfqData['quantity']?.toString() ?? 'Not Available',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, size: 20, color: AppColors.primaryAccent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              rfqData['location'] ?? 'Not Available',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Requirements',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              rfqData['description'] ?? 'No description provided.',
              style: TextStyle(
                color: Colors.grey.shade800,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Specifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (rfqData['specification'] != null && rfqData['specification']!.isNotEmpty)
              ...rfqData['specification']!.map<Widget>((spec) {
                return SpecificationCard(
                  title: spec['key'] ?? 'No title',
                  value: spec['value'] ?? 'No value',
                );
              }).toList(),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: rfqData['rfq_status'] == 'paused'
                          ? Colors.green.shade100
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          rfqData['rfq_status'] == 'paused'
                              ? Icons.play_circle_filled
                              : Icons.pause_circle_filled,
                          color: rfqData['rfq_status'] == 'paused' ? Colors.green : Colors.black,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            _showConfirmationDialog(
                              context: context,
                              title: 'Confirm Command',
                              content: 'Are you sure you want to ${rfqData['rfq_status'] == 'paused' ? 'enable' : 'pause'} this RFQ?',
                              onConfirm: () => _toggleRfqStatus(context),
                            );
                          },
                          child: Text(
                            rfqData['rfq_status'] == 'paused'
                                ? 'Enable Request'
                                : 'Pause Request',
                            style: TextStyle(
                              color: rfqData['rfq_status'] == 'paused' ? Colors.green : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.delete, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            _showConfirmationDialog(
                              context: context,
                              title: 'Confirm Deletion',
                              content: 'Are you sure you want to delete this RFQ?',
                              onConfirm: () => _deleteRfq(context),
                            );
                          },
                          child: const Text(
                            'Delete Request',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
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
