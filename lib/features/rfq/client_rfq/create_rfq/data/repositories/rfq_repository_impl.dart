import 'dart:io';
import '../../domain/entities/rfq_entity.dart';
import '../../domain/repositories/rfq_repository.dart';
import '../datasources/rfq_local_datasource.dart';
import '../datasources/rfq_remote_datasource.dart';

/*
 This orchestrates data sources, so UI only talks to one interface.
 */

class RfqRepositoryImpl implements RfqRepository {
  final RfqRemoteDataSource remote;
  final RfqLocalDataSource local;

  RfqRepositoryImpl({required this.remote, required this.local});

  @override
  Future<void> submitRequest(Rfq rfq, List<File> images) async {

    // 1. Upload attachments
    final allFiles = [...images];
    final urls = <String>[];
    for (final file in allFiles) {
      final url = await remote.uploadFile(file);
      urls.add(url);
    }

    // 2. Attach URLs to entity
    final completeRfq = rfq.copyWith(attachments: urls);
    // 3. Send RFQ
    await remote.createRfq(completeRfq);
    // 4. Optionally cache locally
    await local.cacheRfq(completeRfq);
  }
}
