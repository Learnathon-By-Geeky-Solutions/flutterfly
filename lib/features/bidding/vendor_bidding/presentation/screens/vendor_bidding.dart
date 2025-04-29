import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickdeal/features/bidding/vendor_bidding/presentation/widgets/bid_card.dart';
import '../../../../../common/widget/custom_appbar.dart';
import '../../../../../core/services/routes/app_routes.dart';
import '../../../../../main.dart';

class VendorBidding extends StatefulWidget {
  const VendorBidding({super.key});

  @override
  _VendorBiddingState createState() => _VendorBiddingState();
}

class _VendorBiddingState extends State<VendorBidding> {
  List<Map<String, dynamic>> _myBids = [];
  final String? userId = supabase.auth.currentUser?.id;

  // Fetch Bids and corresponding RFQ info
  Future<void> _fetchMyBids() async {
    final response = await supabase
        .from('bids')
        .select('*, rfqs!bids_rfq_id_fkey(*)') // Fetch the related RFQ data along with the bids
        .eq('vendor_id', userId as Object);

    if (response.isNotEmpty) {
      setState(() {
        _myBids = List<Map<String, dynamic>>.from(response);
      });
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
                  final rfqInfo = bid['rfqs']; // Accessing the related RFQ data
                  return GestureDetector(
                    onTap: () {
                      context.push(
                        AppRoutes.vendorViewOwnBidDetails,
                        extra: {
                          'bid_id': bid['bid_id'],
                          'rfq_id': bid['rfq_id'],
                        },
                      );
                    },
                    child: Column(
                      children: [
                        BidCard(
                          bid: bid,
                          rfqInfo: rfqInfo,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
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
