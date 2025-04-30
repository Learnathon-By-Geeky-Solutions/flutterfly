import 'package:json_annotation/json_annotation.dart';

part 'rfq_entity.g.dart';

@JsonSerializable(explicitToJson: true)
class Rfq {
  final String title;
  final String description;
  final String clientId;
  final List<String> categoryNames;
  final num budget;
  final DateTime biddingDeadline;
  final DateTime? deliveryDeadline;
  final String? location;
  final int? quantity;
  final List<Map<String, String>>? specification;
  final List<String>? attachments;
  final String? currentlySelectedBidId;

  Rfq({
    required this.title,
    required this.description,
    required this.clientId,
    required this.categoryNames,
    required this.budget,
    required this.biddingDeadline,
    this.deliveryDeadline,
    this.location,
    this.quantity,
    this.specification,
    this.attachments,
    this.currentlySelectedBidId,
  });

  Rfq copyWith({
    String? title,
    String? description,
    String? clientId,
    List<String>? categoryNames,
    num? budget,
    DateTime? biddingDeadline,
    DateTime? deliveryDeadline,
    String? location,
    int? quantity,
    List<Map<String, String>>? specification,
    List<String>? attachments,
    String? currentlySelectedBidId,
  }) {
    return Rfq(
      title: title ?? this.title,
      description: description ?? this.description,
      clientId: clientId ?? this.clientId,
      categoryNames: categoryNames ?? this.categoryNames,
      budget: budget ?? this.budget,
      biddingDeadline: biddingDeadline ?? this.biddingDeadline,
      deliveryDeadline: deliveryDeadline ?? this.deliveryDeadline,
      location: location ?? this.location,
      quantity: quantity ?? this.quantity,
      specification: specification ?? this.specification,
      attachments: attachments ?? this.attachments,
      currentlySelectedBidId: currentlySelectedBidId ?? this.currentlySelectedBidId,
    );
  }

  Map<String, dynamic> toJson() => _$RfqToJson(this);
  factory Rfq.fromJson(Map<String, dynamic> json) => _$RfqFromJson(json);
}