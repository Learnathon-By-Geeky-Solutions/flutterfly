// rfq_details_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/rfq.dart';

class RfqDetailsScreen extends StatelessWidget {
  final Rfq rfq;
  const RfqDetailsScreen({Key? key, required this.rfq}) : super(key: key);

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Widget _buildAttachmentTile(String url) {
    final isImage = url.endsWith('.png') ||
        url.endsWith('.jpg') ||
        url.endsWith('.jpeg') ||
        url.contains('image');
    return ListTile(
      leading: Icon(isImage ? Icons.image : Icons.insert_drive_file),
      title: Text(
        url.split('/').last,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => _openUrl(url),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RFQ Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            rfq.title,

          ),
          const SizedBox(height: 12),
          Text(rfq.description),
          const Divider(height: 32),

          Text('Category: ${rfq.categoryId}'),
          const SizedBox(height: 8),
          Text(
            'Budget: ${rfq.minBudget != null ? '\$${rfq.minBudget}' : '-'} '
                'to ${rfq.maxBudget != null ? '\$${rfq.maxBudget}' : '-'}',
          ),
          const SizedBox(height: 8),
          Text(
            'Bidding Deadline: ${DateFormat('MM/dd/yyyy').format(rfq.rfqDeadline)}',
          ),
          const SizedBox(height: 8),
          if (rfq.deliveryDeadline != null)
            Text(
              'Delivery Deadline: '
                  '${DateFormat('MM/dd/yyyy').format(rfq.deliveryDeadline!)}',
            ),
          const Divider(height: 32),

          if (rfq.specification!.isNotEmpty) ...[
            const Text(
              'Specifications:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...?rfq.specification?.map((s) => Text('- $s')),
            const Divider(height: 32),
          ],

          if (rfq.attachments!.isNotEmpty) ...[
            const Text(
              'Attachments:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...?rfq.attachments?.map(_buildAttachmentTile),
          ],
        ],
      ),
    );
  }
}
