import 'package:flutter/material.dart';

class HomeSection extends StatelessWidget {
  final String? companyName;
  final int newRfqCount;
  final int availableRfqCount;
  final int ongoingBidsCount;
  final int confirmedCount;
  final double pendingAmount;

  const HomeSection({
    super.key,
    required this.companyName,
    required this.newRfqCount,
    required this.availableRfqCount,
    required this.ongoingBidsCount,
    required this.confirmedCount,
    required this.pendingAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Welcome header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          decoration: const BoxDecoration(
            color: Color(0xFFFF4D79),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back, $companyName!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                'You have $newRfqCount new RFQs to review',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11.0,
                ),
              ),
            ],
          ),
        ),

        // Stats cards
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  // Available RFQs card
                  Expanded(
                    child: _buildStatCard(
                      title: 'Available RFQs',
                      value: availableRfqCount.toString(),
                      icon: Icons.description,
                      iconColor: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  // Ongoing Bids card
                  Expanded(
                    child: _buildStatCard(
                      title: 'Ongoing Bids',
                      value: ongoingBidsCount.toString(),
                      icon: Icons.access_time,
                      iconColor: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  // Confirmed card
                  Expanded(
                    child: _buildStatCard(
                      title: 'Confirmed',
                      value: confirmedCount.toString(),
                      icon: Icons.check_circle,
                      iconColor: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  // Pending card
                  Expanded(
                    child: _buildStatCard(
                      title: 'Pending',
                      value: '\$${pendingAmount.toStringAsFixed(1)}K',
                      icon: Icons.account_balance_wallet,
                      iconColor: Colors.purple,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 13.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 24.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
