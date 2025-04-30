import 'package:flutter/material.dart';
import 'package:quickdeal/core/utils/helpers/helpers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/utils/constants/color_palette.dart';
import '../../../../../main.dart';
import '../../../../rfq/client_rfq/view_rfq/widgets/specification_card.dart';

class VendorViewOwnBidDetails extends StatefulWidget {
  final String bidId;
  final String rfqId;

  const VendorViewOwnBidDetails({super.key, required this.bidId, required this.rfqId});

  @override
  _VendorViewOwnBidDetailsState createState() =>
      _VendorViewOwnBidDetailsState();
}

class _VendorViewOwnBidDetailsState extends State<VendorViewOwnBidDetails> {
  Map<String, dynamic>? bidData;
  Map<String, dynamic>? rfqData;
  double? _currentBid;
  bool isLoading = true;
  int outBidsCount = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    listenToRfqsUpdates();
    listenToBidsUpdates();
  }

  void _loadInitialData() async {
    try {
      final fetchedBid = await _fetchBidDetails();
      final fetchedRfq = await _fetchRfqDetails();
      final selectedBidId = fetchedRfq?['currently_selected_bid_id'];

      if (selectedBidId != null) {
        final response = await supabase
            .from('bids')
            .select('proposed_price_per_item')
            .eq('bid_id', selectedBidId)
            .single();

        if (response['proposed_price_per_item'] != null) {
          _currentBid = response['proposed_price_per_item'];
        }
      }

      int lowerBidCount = 0;

      if (fetchedBid != null) {
        final myBidAmount = fetchedBid['proposed_price_per_item'];
        if (myBidAmount != null) {
          final lowerBidsResponse = await supabase
              .from('bids')
              .select('bid_id')
              .eq('rfq_id', widget.rfqId)
              .lt('proposed_price_per_item', myBidAmount);

          lowerBidCount = lowerBidsResponse.length;
        }
      }

      setState(() {
        bidData = fetchedBid;
        rfqData = fetchedRfq;
        outBidsCount = lowerBidCount;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fetch Bid Details
  Future<Map<String, dynamic>?> _fetchBidDetails() async {
    try {
      print("Fetching Bid Details for: ${widget.bidId}");
      final response = await supabase.from('bids').select().eq('bid_id', widget.bidId).single();
      return response;
    } catch (e) {
      print("Error fetching bid details: $e");
      return null;
    }
  }

  // Fetch RFQ Details
  Future<Map<String, dynamic>?> _fetchRfqDetails() async {
    try {
      print("Fetching RFQ Details for: ${widget.rfqId}");
      final response = await supabase.from('rfqs').select().eq('rfq_id', widget.rfqId).single();
      return response;
    } catch (e) {
      print("Error fetching RFQ details: $e");
      return null;
    }
  }

  // Listen to RFQ Updates and Update UI if Necessary
  void listenToRfqsUpdates() {
    final subscription = supabase
        .channel('rfqs_changes')
        .onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'rfqs',
      callback: (payload) async {
        print("Received update payload: $payload");

        final newRecord = payload.newRecord;
        if (newRecord['currently_selected_bid_id'] != null) {
          final newSelectedBidId = newRecord['currently_selected_bid_id'];

          final response = await supabase
              .from('bids')
              .select('proposed_price_per_item')
              .eq('bid_id', newSelectedBidId)
              .single();

          if (response['proposed_price_per_item'] != null) {
            updateUIWithBidAmount(response['proposed_price_per_item']);
          }
        }
      },
    )
        .subscribe();

    print("Subscribed to rfqs changes: ${subscription.presence}");
  }

  void listenToBidsUpdates() {
    final subscription = supabase
        .channel('bids_changes')
        .onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'bids',
      callback: (payload) async {
        double newBidAmount = payload.newRecord['proposed_price_per_item'];

        if (_currentBid != null && newBidAmount < _currentBid!) {
          setState(() {
            outBidsCount++;
          });
        }
      },
    )
        .subscribe();

    print("Subscribed to bids changes: ${subscription.presence}");
  }

  void updateUIWithBidAmount(double bidAmount) {
    setState(() {
      _currentBid = bidAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: AppHelperFunctions.appLoader(context));
    }

    if (bidData == null || rfqData == null) {
      return const Center(child: Text('No data found'));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Bid Details',
          style: TextStyle(color: Colors.black87),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductHeader(rfqData!),
            _buildBidStatus(),
            _buildDivider(),
            _buildSpecificationsSection(),
            _buildDivider(),
            _buildClientRequestDetails(rfqData!),
            _buildDivider(),
            _buildYourBid(bidData!),
            const SizedBox(height: 20),
            _buildWithdrawButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Build UI for Product Header
  Widget _buildProductHeader(Map<String, dynamic> rfqData) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rfqData['title'] ?? 'Unknown Product',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rfqData['description'] ?? 'No description available',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child:
              Padding(
          padding: const EdgeInsets.only(top: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: rfqData['category_names']
            .map<Widget>((category) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryAccent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            category,
            style: TextStyle(
              color: AppColors.primaryAccent,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ))
            .toList(),
      ),
    ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build UI for Bid Status
  Widget _buildBidStatus() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.center,
              child: Text(
                'Current Bid: ${_currentBid != null ? '$_currentBid ৳' : 'N/A'}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.center,
              child: Text(
                'My Bid: ${bidData?['proposed_price_per_item'] ?? 'Not Available'}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.center,
              child: Text(
                'Out Bids: $outBidsCount',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecificationsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Specifications', style: TextStyle(fontSize: 14,
              fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (rfqData?['specification'] != null && rfqData?['specification']!
              .isNotEmpty)
            ...rfqData?['specification']!.map<Widget>((spec) {
              return SpecificationCard(
                title: spec['key'] ?? 'No title',
                value: spec['value'] ?? 'No value',
              );
            }).toList(),
        ],
      ),
    );
  }

  // Build UI for Client Request Details
  Widget _buildClientRequestDetails(Map<String, dynamic> rfqData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Client Request Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Quantity Needed', (rfqData['quantity']?.toString() ?? 'Unknown')),
          const SizedBox(height: 12),
          _buildDetailRow('Estd. Budget', '${(rfqData['budget'] ?? 0).toString()} ৳'),
          const SizedBox(height: 12),
          _buildDetailRow('Delivery Deadline',
              AppHelperFunctions.formatDate(rfqData['delivery_deadline']) ?? 'Unknown'),
          const SizedBox(height: 12),
          _buildLocationRow(rfqData['location'] ?? 'Unknown'),
        ],
      ),
    );
  }

  // Build UI for Your Bid
  Widget _buildYourBid(Map<String, dynamic> bidData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Bid',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFD54F)),
                ),
                child: const Text(
                  'Under Review',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFF8F00),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            'Proposed Amount',
            '${bidData['proposed_price_per_item'] ?? 'N/A'} ৳/unit',
            valueColor: Colors.green,
            valueFontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Your Delivery Date', AppHelperFunctions.formatDate(bidData['created_at'] )?? 'N/A'),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Build UI for Detail Row (e.g. Quantity, Deadline, etc.)
  Widget _buildDetailRow(
      String label,
      String value, {
        Color? valueColor,
        FontWeight? valueFontWeight,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            color: valueColor ?? Colors.black87,
            fontWeight: valueFontWeight ?? FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationRow(String location) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Location',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          Expanded(
            child: Text(
              location ?? 'Unknown',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black87,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }



  // Divider
  Widget _buildDivider() {
    return const Divider(
      color: Colors.grey,
      thickness: 1,
      height: 30,
    );
  }

  // Build UI for Withdraw Button
  Widget _buildWithdrawButton() {

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20),
          SizedBox(width: 8),
          Text(
            'Withdraw Bid',
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );


  }
}
