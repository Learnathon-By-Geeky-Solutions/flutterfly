import '../../domain/entities/rfq_entity.dart';

class RfqModel {
  final String title;
  final String description;
  final String clientId;
  final String categoryId;
  final num? minBudget;
  final num? maxBudget;
  final DateTime biddingDeadline;
  final DateTime? deliveryDeadline;
  final List<String>? attachments;

  RfqModel({
    required this.title,
    required this.description,
    required this.clientId,
    required this.categoryId,
    this.minBudget,
    this.maxBudget,
    required this.biddingDeadline,
    required this.deliveryDeadline,
    this.attachments,
  });

  factory RfqModel.fromJson(Map<String, dynamic> json) => RfqModel(
    title: json['title'],
    description: json['description'],
    clientId: json['client_id'],
    categoryId: json['category_id'],
    minBudget: json['min_budget'],
    maxBudget: json['max_budget'],
    biddingDeadline: DateTime.parse(json['bidding_deadline']),
    deliveryDeadline: json['delivery_deadline'] != null
        ? DateTime.parse(json['delivery_deadline'])
        : null,
    attachments: List<String>.from(json['attachments'] ?? []),
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'client_id': clientId,
    'category_id': categoryId,
    'min_budget': minBudget,
    'max_budget': maxBudget,
    'bidding_deadline': biddingDeadline.toIso8601String(),
    'delivery_deadline': deliveryDeadline?.toIso8601String(),
    'attachments': attachments,
  };

  Rfq toEntity() => Rfq(
    title: title,
    description: description,
    clientId: clientId,
    categoryId: categoryId,
    minBudget: minBudget,
    maxBudget: maxBudget,
    biddingDeadline: biddingDeadline,
    deliveryDeadline: deliveryDeadline,
    attachments: attachments,
  );

  factory RfqModel.fromEntity(Rfq entity) => RfqModel(
    title: entity.title,
    description: entity.description,
    clientId: entity.clientId,
    categoryId: entity.categoryId,
    minBudget: entity.minBudget,
    maxBudget: entity.maxBudget,
    biddingDeadline: entity.biddingDeadline,
    deliveryDeadline: entity.deliveryDeadline,
    attachments: entity.attachments,
  );
}