import 'package:flutter/material.dart';

class BidItem {
  final String title;
  final String clientName;
  final double bidAmount;
  final int daysLeft;
  final String status;

  const BidItem({
    required this.title,
    required this.clientName,
    required this.bidAmount,
    required this.daysLeft,
    required this.status,
  });

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'in review':
        return Colors.amber;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color get statusBackgroundColor {
    switch (status.toLowerCase()) {
      case 'in review':
        return Colors.amber.withOpacity(0.1);
      case 'accepted':
        return Colors.green.withOpacity(0.1);
      case 'rejected':
        return Colors.red.withOpacity(0.1);
      default:
        return Colors.grey.withOpacity(0.1);
    }
  }
}

class OngoingBidsSection extends StatelessWidget {
  final List<BidItem> bidItems;
  final Function(BidItem)? onBidTap;

  const OngoingBidsSection({
    super.key,
    required this.bidItems,
    this.onBidTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Ongoing Bids',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: bidItems.length,
          itemBuilder: (context, index) {
            final item = bidItems[index];
            return _buildBidCard(context, item);
          },
        ),
      ],
    );
  }

  Widget _buildBidCard(BuildContext context, BidItem item) {
    return InkWell(
      onTap: onBidTap != null ? () => onBidTap!(item) : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: item.statusBackgroundColor,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    item.status,
                    style: TextStyle(
                      color: item.statusColor,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            Text(
              'Client: ${item.clientName}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14.0,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Your Bid: ',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '\$${item.bidAmount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Time Left: ',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '${item.daysLeft} days',
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
