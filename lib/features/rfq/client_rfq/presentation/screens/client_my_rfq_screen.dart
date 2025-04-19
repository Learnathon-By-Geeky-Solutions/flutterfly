// client_my_rfq_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/rfq.dart';
import 'rfq_details_screen.dart';

final _supabase = Supabase.instance.client;

class ClientMyRfqScreen extends StatefulWidget {
  const ClientMyRfqScreen({Key? key}) : super(key: key);

  @override
  _ClientMyRfqScreenState createState() => _ClientMyRfqScreenState();
}

class _ClientMyRfqScreenState extends State<ClientMyRfqScreen> {
  late Future<List<Rfq>> _rfqsFuture;

  @override
  void initState() {
    super.initState();
    _rfqsFuture = _fetchRfqs();
  }

  Future<List<Rfq>> _fetchRfqs() async {
    final userId = _supabase.auth.currentUser?.id ?? '';
    // First, fetch the client_id for this user
    final clientRes = await _supabase
        .from('clients')
        .select('client_id')
        .eq('client_id', userId)
        .maybeSingle();
    final clientId = clientRes?['client_id'] as String;

    // Then fetch RFQs for that client
    final data = await _supabase
        .from('rfqs')
        .select()
        .eq('client_id', clientId);
    return (data as List)
        .map((e) => Rfq.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My RFQs')),
      body: FutureBuilder<List<Rfq>>(
        future: _rfqsFuture,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final rfqs = snap.data!;
          if (rfqs.isEmpty) {
            return const Center(child: Text('No RFQs found.'));
          }
          return RefreshIndicator(
            onRefresh: () async {
              setState(() => _rfqsFuture = _fetchRfqs());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: rfqs.length,
              itemBuilder: (context, i) {
                final rfq = rfqs[i];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rfq.title,
                        //  style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          rfq.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Text(
                              'Bidding by ${DateFormat('MM/dd/yyyy').format(rfq.rfqDeadline)}',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RfqDetailsScreen(rfq: rfq),
                                ),
                              );
                            },
                            child: const Text('View Details'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
