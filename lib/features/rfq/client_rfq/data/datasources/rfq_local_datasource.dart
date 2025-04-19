import '../../../../../core/network/local/local_service.dart';
import '../../domain/entities/rfq_entity.dart';

abstract class RfqLocalDataSource {
  Future<void> cacheRfq(Rfq rfq);
}

class RfqLocalDataSourceImpl implements RfqLocalDataSource {
  final LocalService local;
  RfqLocalDataSourceImpl(this.local);

  @override
  Future<void> cacheRfq(Rfq rfq) =>
      local.cacheRfq(rfq);
}