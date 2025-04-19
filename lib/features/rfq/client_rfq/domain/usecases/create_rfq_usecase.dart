import 'dart:io';
import '../entities/rfq_entity.dart';
import '../repositories/rfq_repository.dart';

class CreateRfqUseCase {
  final RfqRepository repo;
  CreateRfqUseCase(this.repo);

  Future<void> execute({
    required String title,
    required String desc,
    required String clientId,
    required String categoryId,
    required num? min,
    required num? max,
    required DateTime bidBy,
    required DateTime deliverBy,
    required List<File> images,
    required List<File> docs,
  }) {
    final rfq = Rfq(
      title: title,
      description: desc,
      clientId: clientId,
      categoryId: categoryId,
      minBudget: min,
      maxBudget: max,
      biddingDeadline: bidBy,
      deliveryDeadline: deliverBy,
      attachments: [],
    );
    return repo.submitRequest(rfq, images, docs);
  }
}
