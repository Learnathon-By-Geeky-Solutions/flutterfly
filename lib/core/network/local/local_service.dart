import '../../../features/rfq/client_rfq/domain/entities/rfq_entity.dart';
import '../../services/memory_management/hive/hive_service.dart';

/*
  Used for offline-first features or quick restores after a crash.
 */

class LocalService {
  final HiveService hive;
  LocalService(this.hive);

  Future<void> cacheRfq(Rfq rfq) async {
    final box = hive.box<Rfq>('rfqs');
    await box.put(rfq.clientId, rfq); //TODO: Change to Rfq ID
  }
}