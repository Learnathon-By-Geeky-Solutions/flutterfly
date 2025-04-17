import 'package:flutter/material.dart';

class RfqItem {
  final String title;
  final String category;
  final String? description;
  final List<String> tags;
  final int daysLeft;
  final String priceRange;
  final bool isNew;

  const RfqItem({
    required this.title,
    required this.category,
    this.description,
    required this.tags,
    required this.daysLeft,
    required this.priceRange,
    this.isNew = false,
  });
}

class AvailableRfqSection extends StatelessWidget {
  final List<RfqItem> rfqItems;
  final Function(RfqItem) onViewDetails;
  final Function(RfqItem) onPlaceBid;

  const AvailableRfqSection({
    super.key,
    required this.rfqItems,
    required this.onViewDetails,
    required this.onPlaceBid,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Available RFQs',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rfqItems.length,
          itemBuilder: (context, index) {
            final item = rfqItems[index];
            return _buildRfqCard(context, item);
          },
        ),
      ],
    );
  }

  Widget _buildRfqCard(BuildContext context, RfqItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                    if (item.isNew)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: const Text(
                          'New',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  item.category,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                if (item.description != null) ...[
                  Text(
                    item.description!,
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 14.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                ],
                Wrap(
                  spacing: 8.0,
                  children: item.tags.map((tag) {
                    return Chip(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      label: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.deepOrange,
                        ),
                      ),
                      backgroundColor: Colors.deepOrange.withOpacity(0.1),
                      padding: const EdgeInsets.all(0),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16.0,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '${item.daysLeft} days left',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Icon(
                      Icons.attach_money,
                      size: 16.0,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      item.priceRange,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => onViewDetails(item),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8.0),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'View Details',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => onPlaceBid(item),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF4D79),
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(8.0),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Place Bid',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}