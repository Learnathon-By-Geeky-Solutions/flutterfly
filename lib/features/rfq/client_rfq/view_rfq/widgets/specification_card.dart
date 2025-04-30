import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/color_palette.dart';

class SpecificationCard extends StatelessWidget {
  final String title;
  final String value;

  const SpecificationCard({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryAccent,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color:  Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
