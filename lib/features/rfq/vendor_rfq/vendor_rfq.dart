import 'package:flutter/material.dart';
import 'package:quickdeal/features/rfq/vendor_rfq/widgets/rfq_card.dart';
import 'package:quickdeal/common/widget/custom_appbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/utils/helpers/helpers.dart';

class VendorRfq extends StatefulWidget {
  const VendorRfq({super.key});

  @override
  State<VendorRfq> createState() => _VendorRfqState();
}

class _VendorRfqState extends State<VendorRfq> {
  final SupabaseClient supabase = Supabase.instance.client;

  List<Map<String, dynamic>> rfqs = [];
  List<Map<String, dynamic>> filteredRfqs = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchRfqs();

    // Listen to changes in the search input
    searchController.addListener(() {
      filterRfqs(searchController.text);
    });
  }

  Future<void> fetchRfqs() async {
    setState(() {
      isLoading = true;
    });

    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('User not logged in');
      }

      // Step 1: Fetch the services offered by the vendor
      final vendorResponse = await supabase
          .from('vendors')
          .select('services_offered')
          .eq('vendor_id', userId)
          .single();

      List<String> servicesOffered = List<String>.from(vendorResponse['services_offered']);

      if (servicesOffered.isEmpty) {
        throw Exception('Vendor has no services offered');
      }

      // Step 2: Fetch rfq_ids the vendor has already placed bids on
      final bidResponse = await supabase
          .from('bids')
          .select('rfq_id')
          .eq('vendor_id', userId);

      final List<String> rfqIdsBidOn = List<Map<String, dynamic>>.from(bidResponse)
          .map((e) => e['rfq_id'].toString())
          .toList();

      // Step 3: Fetch RFQs that match vendor's services and are NOT already bid on
      final response = await supabase
          .from('rfqs')
          .select(''' 
      rfq_id,
      client_id,
      category_names,
      title,
      description,
      budget,
      bidding_deadline,
      rfq_status,
      location,
      quantity,
      specification,
      delivery_deadline,
      attachments,
      created_at,
      updated_at,
      currently_selected_bid_id,
      clients(full_name, profile_pic)
    ''')
          .eq('rfq_status', 'ongoing')
      // Ensure category_names is compared with an array of strings (servicesOffered)
          .filter('category_names', 'cs', servicesOffered)  // Array subset filter for category_names
          .order('created_at', ascending: false);

      // Step 4: Remove any RFQ already bid on
      final List<Map<String, dynamic>> allRfqs = List<Map<String, dynamic>>.from(response);
      final filteredOutBids = allRfqs
          .where((rfq) => !rfqIdsBidOn.contains(rfq['rfq_id'].toString()))
          .toList();

      setState(() {
        rfqs = filteredOutBids;
        filteredRfqs = List<Map<String, dynamic>>.from(filteredOutBids);
        isLoading = false;
      });

    } catch (e) {
      debugPrint('Error fetching RFQs: $e');
      setState(() {
        isLoading = false;
      });
    }
  }


  // Function to filter RFQs based on search query
  void filterRfqs(String query) {
    final filtered = rfqs.where((rfq) {
      final title = rfq['title']?.toLowerCase() ?? '';
      final description = rfq['description']?.toLowerCase() ?? '';
      final lowerQuery = query.toLowerCase();

      // Search matches either title or description
      return title.contains(lowerQuery) || description.contains(lowerQuery);
    }).toList();

    setState(() {
      filteredRfqs = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
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
                    color: Colors.grey[200]! ,
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
            // The Search Bar will stay independent of the RFQ list
            Container(
              height: 80,
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search RFQs...',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
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

            Expanded(
              child: Container(
                color: Colors.grey[50],
                child: isLoading
                    ? Center(child: AppHelperFunctions.appLoader(context))
                    : filteredRfqs.isEmpty
                    ? const Center(child: Text('No RFQs found'))
                    : ListView(
                  padding: const EdgeInsets.all(8),
                  children: [
                    // All RFQs Available Text with some space below it
                    const Text(
                      'All RFQs available to you',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16), // Add space after the text
                    // RFQ Cards
                    ...filteredRfqs.map((rfq) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: RFQCard(
                          rfq: rfq,
                          title: rfq['title'] ?? 'No Title',
                          description: _trimDescription(rfq['description'] ?? 'No Description'),
                          company: rfq['clients']?['full_name'] ?? 'Unknown',
                          deadline: rfq['bidding_deadline'] != null
                              ? DateTime.parse(rfq['bidding_deadline']).toLocal().toString().split(' ')[0]
                              : 'No Deadline',
                          budget: rfq['budget'].toString(),
                          status: rfq['rfq_status'] ?? 'ongoing', // Pass status correctly here
                        ),
                      );
                    }),

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

String _trimDescription(String description, {int maxLength = 150}) {
  if (description.length <= maxLength) {
    return description;
  }
  return '${description.substring(0, maxLength).trim()}...';
}
