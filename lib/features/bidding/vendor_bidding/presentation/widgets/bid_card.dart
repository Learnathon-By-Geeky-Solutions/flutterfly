import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:quickdeal/core/utils/helpers/helpers.dart';
import '../../../../../core/services/routes/app_routes.dart';

class BidCard extends StatelessWidget {
  final Map<String, dynamic> bid;
  final Map<String, dynamic>? rfqInfo;

  const BidCard({
    super.key,
    required this.bid,
    required this.rfqInfo,
  });

  @override
  Widget build(BuildContext context) {
    // Extract individual properties from the bid map
    final String projectTitle = rfqInfo?['title'] ?? 'No Title';
    final String bidAmount = '${bid['proposed_price_per_item'] ?? 0}';
    final String submittedDate = bid['created_at'] != null
        ? DateFormat('MMM dd, yyyy').format(DateTime.parse(bid['created_at']))
        : 'No Date';
    final String status = bid['status'] ?? 'Pending';
    final Color statusColor = status == 'Accepted'
        ? Color(0xFFE0F7E6)
        : status == 'Rejected'
        ? Color(0xFFFAE3E3)
        : Color(0xFFF8EAC0);
    final Color statusTextColor = status == 'Accepted'
        ? Color(0xFF2D9D5B)
        : status == 'Rejected'
        ? Color(0xFFD85050)
        : Color(0xFFB7953F);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppHelperFunctions.limitWords(projectTitle, 15),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Proposed Amount per Item',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$bidAmount৳',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Submitted',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      submittedDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[900],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Passing specific bid_id and rfq_id to the next page
                  context.push(
                    AppRoutes.vendorViewOwnBidDetails,
                    extra: {
                      'bid_id': bid['bid_id'],
                      'rfq_id': bid['rfq_id'],
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5A7E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
