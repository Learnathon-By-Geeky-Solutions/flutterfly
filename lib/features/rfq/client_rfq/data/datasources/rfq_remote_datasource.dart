import 'dart:io';
import '../../../../../core/network/remote/remote_service.dart';
import '../../domain/entities/rfq_entity.dart';
import '../models/rfq_model.dart';

abstract class RfqRemoteDataSource {
  Future<String> uploadFile(File file);
  Future<void> createRfq(Rfq rfq);
}

class RfqRemoteDataSourceImpl implements RfqRemoteDataSource {
  final RemoteService remote;
  RfqRemoteDataSourceImpl(this.remote);

  @override
  Future<String> uploadFile(File file) async {
   final bytes = await file.readAsBytes();
   final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
   final resp = await remote.post(
       '/upload',
       {'fileName': fileName, 'bytes': bytes}
   );
   return resp.data['url'];
  }

  @override
  Future<void> createRfq(Rfq rfq) async {
    final model = RfqModel.fromEntity(rfq);
    await remote.post(
      '/rfqs',
      model.toJson(),
    );
  }
}