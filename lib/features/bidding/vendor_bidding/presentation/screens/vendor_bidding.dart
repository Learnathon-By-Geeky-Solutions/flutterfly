import 'package:flutter/material.dart';
import 'package:quickdeal/features/bidding/vendor_bidding/presentation/widgets/bid_card.dart';
import 'package:intl/intl.dart';
import '../../../../../common/widget/custom_appbar.dart';
import '../../../../../main.dart';

class VendorBidding extends StatefulWidget {
  const VendorBidding({super.key});

  @override
  _VendorBiddingState createState() => _VendorBiddingState();
}

class _VendorBiddingState extends State<VendorBidding> {
  List<Map<String, dynamic>> _myBids = [];
  final String? userId = supabase.auth.currentUser?.id;
  Map<String, dynamic>? _rfqInfo;  // To hold the RFQ info

  // Fetch RFQ info based on rfq_id
  Future<void> _fetchRFQInfo(String rfqId) async {
    final response = await supabase.from('rfqs').select().eq('rfq_id', rfqId).single();

    setState(() {
      _rfqInfo = response;
    });
    }

  // Fetch Bids and corresponding RFQ info
  Future<void> _fetchMyBids() async {
    final response = await supabase
        .from('bids')
        .select()
        .eq('vendor_id', userId as Object);

    print('Response: $response');

    if (response.isNotEmpty) {
      setState(() {
        _myBids = List<Map<String, dynamic>>.from(response);
      });

      // Fetch RFQ info for the first bid (assuming rfq_id is present in all bids)
      final rfqId = _myBids.first['rfq_id'];
      if (rfqId != null) {
        await _fetchRFQInfo(rfqId);  // Fetch the RFQ information
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMyBids();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search bids...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 13,
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
              child: _myBids.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _myBids.length,
                itemBuilder: (context, index) {
                  final bid = _myBids[index];

                  return Column(
                    children: [
                      BidCard(
                        projectTitle: _rfqInfo?['title'] ?? 'No Title',
                        bidAmount: '\$${bid['proposed_price_per_item']}',
                        submittedDate: DateFormat('MMM dd, yyyy').format(
                          DateTime.parse(bid['created_at']),
                        ),
                        status: bid['status'] ?? 'No Status',
                        statusColor: bid['status'] == 'Accepted'
                            ? Color(0xFFE0F7E6)
                            : bid['status'] == 'Rejected'
                            ? Color(0xFFFAE3E3)
                            : Color(0xFFF8EAC0),
                        statusTextColor: bid['status'] == 'Accepted'
                            ? Color(0xFF2D9D5B)
                            : bid['status'] == 'Rejected'
                            ? Color(0xFFD85050)
                            : Color(0xFFB7953F),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
