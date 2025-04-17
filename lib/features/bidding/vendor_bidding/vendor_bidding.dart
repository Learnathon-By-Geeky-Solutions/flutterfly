import 'package:flutter/material.dart';
import 'package:quickdeal/features/bidding/vendor_bidding/widgets/bid_card.dart';

class VendorBidding extends StatelessWidget {
  const VendorBidding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'My Bids',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search projects...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[800],
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      selected: true,
                      label: const Text(
                        'All Bids',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      backgroundColor: Colors.white,
                      selectedColor: const Color(0xFFFF5A7E),
                      onSelected: (bool selected) {},
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                    const SizedBox(width: 12),
                    FilterChip(
                      selected: false,
                      label: Text(
                        'Pending',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      backgroundColor: Colors.white,
                      onSelected: (bool selected) {},
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                    const SizedBox(width: 12),
                    FilterChip(
                      selected: false,
                      label: Text(
                        'Accepted',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      backgroundColor: Colors.white,
                      onSelected: (bool selected) {},
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                    const SizedBox(width: 12),
                    FilterChip(
                      selected: false,
                      label: Text(
                        'Rejected',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      backgroundColor: Colors.white,
                      onSelected: (bool selected) {},
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bid Cards
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  BidCard(
                    projectTitle: 'Office Renovation Project',
                    bidAmount: '\$45,000',
                    submittedDate: 'Jan 15, 2025',
                    status: 'Pending',
                    statusColor: Color(0xFFF8EAC0),
                    statusTextColor: Color(0xFFB7953F),
                  ),
                  SizedBox(height: 16),
                  BidCard(
                    projectTitle: 'Restaurant Design',
                    bidAmount: '\$28,500',
                    submittedDate: 'Jan 10, 2025',
                    status: 'Accepted',
                    statusColor: Color(0xFFE0F7E6),
                    statusTextColor: Color(0xFF2D9D5B),
                  ),
                  SizedBox(height: 16),
                  BidCard(
                    projectTitle: 'Hotel Lobby Redesign',
                    bidAmount: '\$35,000',
                    submittedDate: 'Jan 5, 2025',
                    status: 'Rejected',
                    statusColor: Color(0xFFFAE3E3),
                    statusTextColor: Color(0xFFD85050),
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