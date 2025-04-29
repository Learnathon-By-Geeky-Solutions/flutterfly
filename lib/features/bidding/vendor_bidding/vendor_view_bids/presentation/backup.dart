import 'package:flutter/material.dart';
import '../../../../../main.dart';

class VendorViewOwnBidDetails extends StatefulWidget {
  final String bidId;
  final String rfqId;

  const VendorViewOwnBidDetails({super.key, required this.bidId, required this.rfqId});

  @override
  _VendorViewOwnBidDetailsState createState() =>
      _VendorViewOwnBidDetailsState();
}

class _VendorViewOwnBidDetailsState extends State<VendorViewOwnBidDetails> {
  late Future<Map<String, dynamic>?> bidDetails;
  late Future<Map<String, dynamic>?> rfqDetails;

  @override
  void initState() {
    super.initState();
    bidDetails = _fetchBidDetails();
    rfqDetails = _fetchRfqDetails();
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

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder(
        future: Future.wait([bidDetails, rfqDetails]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data![0] == null || snapshot.data![1] == null) {
            return const Center(child: Text('No data found'));
          }

          final bidData = snapshot.data![0] as Map<String, dynamic>;
          final rfqData = snapshot.data![1] as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductHeader(rfqData),
                _buildBidStatus(bidData),
                _buildDivider(),
                _buildSpecifications(bidData),
                _buildDivider(),
                _buildClientRequestDetails(rfqData),
                _buildDivider(),
                _buildYourBid(bidData),
                const SizedBox(height: 20),
                _buildWithdrawButton(),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
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
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha:0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Image.network(
              rfqData['product_image_url'] ?? 'https://via.placeholder.com/80', // Use the actual URL or placeholder
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rfqData['title'] ?? 'Unknown Product',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rfqData['description'] ?? 'No description available',
                  style: const TextStyle(
                    fontSize: 14,
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
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    rfqData['category'] ?? 'Category',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
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
  Widget _buildBidStatus(Map<String, dynamic> bidData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Current Bid: \$170',
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
              child: const Text(
                'My Bid: 10',
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
              child: const Text(
                'Out Bids: 03',
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

  // Build UI for Specifications
  Widget _buildSpecifications(Map<String, dynamic> bidData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Specifications',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Material',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Mesh & Metal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Weight',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '15 kg',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
          _buildDetailRow('Quantity Needed', rfqData['quantity_needed'] ?? 'Unknown'),
          const SizedBox(height: 12),
          _buildDetailRow('Budget Range', (rfqData['min_budget'] ?? 0).toString()),
          const SizedBox(height: 12),
          _buildDetailRow('Delivery Deadline', rfqData['delivery_deadline'] ??
              'Unknown'),
          const SizedBox(height: 12),
          _buildDetailRow('Location', rfqData['location'] ?? 'Unknown'),
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
            '\$${bidData['proposed_price_per_item'] ?? 'N/A'}/unit',
            valueColor: Colors.green,
            valueFontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Submission Date', bidData['created_at'] ?? 'N/A'),
          const SizedBox(height: 16),
          _buildProposalDownload(bidData),
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
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: valueColor ?? Colors.black87,
            fontWeight: valueFontWeight ?? FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Build UI for Proposal Download
  Widget _buildProposalDownload(Map<String, dynamic> bidData) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.insert_drive_file_outlined,
            color: Colors.black54,
            size: 20,
          ),
          const SizedBox(width: 12),
          const Text(
            'Proposal.pdf',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {

            },
            icon: const Icon(
              Icons.download,
              color: Colors.blue,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // Build UI for Withdraw Button
  Widget _buildWithdrawButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF4081),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Withdraw Bid',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Divider Widget
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        height: 8,
        color: Colors.grey[100],
      ),
    );
  }
}
