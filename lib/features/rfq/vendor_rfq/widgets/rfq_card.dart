import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/routes/app_routes.dart';

class RFQCard extends StatelessWidget {
  final String title;
  final String description;
  final String company;
  final String deadline;
  final String budget;
  final bool isNew;
  final Map<String, dynamic> rfq;

  const RFQCard({
    super.key,
    required this.title,
    required this.description,
    required this.company,
    required this.deadline,
    required this.budget,
    required this.isNew,
    required this.rfq,
  });

  @override
  Widget build(BuildContext context) {
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
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                if (isNew)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F7E6),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Text(
                      'New',
                      style: TextStyle(
                        color: Color(0xFF2D9D5B),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.business, size: 18, color: Colors.grey[700]),
                const SizedBox(width: 8),
                Text(
                  company,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 18, color: Colors.grey[700]),
                const SizedBox(width: 8),
                Text(
                  'Deadline: $deadline',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.label, size: 18, color: Colors.grey[700]),
                const SizedBox(width: 8),
                Text(
                  'Budget: $budget',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  context.push(
                      AppRoutes.vendorViewRfqDetailsScreen,
                      extra: rfq);
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
                    fontSize: 16,
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