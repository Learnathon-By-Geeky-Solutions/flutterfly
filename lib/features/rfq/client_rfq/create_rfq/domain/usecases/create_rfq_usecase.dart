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
    required List<String> categoryNames,
    required num budget,
    required DateTime bidBy,
    DateTime? deliverBy,
    String? location,
    int? quantity,
    List<Map<String, String>>? specification,
    List<File>? images,
  }) {
    final rfq = Rfq(
      title: title,
      description: desc,
      clientId: clientId,
      categoryNames: categoryNames,
      budget: budget,
      biddingDeadline: bidBy,
      deliveryDeadline: deliverBy,
      location: location,
      quantity: quantity,
      specification: specification,
      attachments: [],
    );

    return repo.submitRequest(rfq, images!);
  }
}