import 'package:flutter/material.dart';
import 'package:quickdeal/features/rfq/vendor_rfq/widgets/rfq_card.dart';
import '../../../common/widget/custom_appbar.dart';

class VendorRfq extends StatelessWidget {
  const VendorRfq({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
              ),
              child: const Text(
                'Available RFQs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey[50],
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Search Bar
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search RFQs...',
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
                    const SizedBox(height: 16),

                    // Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterChip(
                            selected: true,
                            label: const Text(
                              'All\nRFQs',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            backgroundColor: const Color(0xFFFF5A7E),
                            selectedColor: const Color(0xFFFF5A7E),
                            onSelected: (bool selected) {},
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(16),
                          ),
                          const SizedBox(width: 12),
                          FilterChip(
                            selected: false,
                            label: const Text(
                              'Technology',
                              style: TextStyle(
                                color: Color(0xFF2D3142),
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
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                          ),
                          const SizedBox(width: 12),
                          FilterChip(
                            selected: false,
                            label: const Text(
                              'Construction',
                              style: TextStyle(
                                color: Color(0xFF2D3142),
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
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                          ),
                          const SizedBox(width: 12),
                          FilterChip(
                            selected: false,
                            label: const Text(
                              'S',
                              style: TextStyle(
                                color: Color(0xFF2D3142),
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
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // RFQ Cards
                    RFQCard(
                      title: 'Website Redesign Project',
                      description: 'Looking for a skilled web design agency to redesign our corporate website with modern UI/UX principles.',
                      company: 'Tech Solutions Inc.',
                      deadline: 'Mar 15, 2025',
                      budget: '\$15,000 - \$25,000',
                      isNew: true,
                    ),
                    const SizedBox(height: 16),
                    RFQCard(
                      title: 'Mobile App Development',
                      description: 'Seeking experienced mobile app developers for iOS and Android platforms. Native development required.',
                      company: 'Mobile Innovations Ltd.',
                      deadline: 'Feb 28, 2025',
                      budget: '\$30,000 - \$50,000',
                      isNew: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}