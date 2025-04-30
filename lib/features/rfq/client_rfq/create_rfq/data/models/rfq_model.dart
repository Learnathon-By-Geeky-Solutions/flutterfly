import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/rfq_entity.dart';

part 'rfq_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RfqModel {
  final String title;
  final String description;

  @JsonKey(name: 'client_id')
  final String clientId;

  @JsonKey(name: 'category_names')
  final List<String> categoryNames;

  final num budget;

  @JsonKey(name: 'bidding_deadline')
  final DateTime biddingDeadline;

  @JsonKey(name: 'delivery_deadline')
  final DateTime? deliveryDeadline;

  final String? location;
  final int? quantity;

  final List<Map<String, String>>? specification;

  final List<String>? attachments;

  @JsonKey(name: 'currently_selected_bid_id')
  final String? currentlySelectedBidId;

  const RfqModel({
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

  factory RfqModel.fromJson(Map<String, dynamic> json) => _$RfqModelFromJson(json);
  Map<String, dynamic> toJson() => _$RfqModelToJson(this);

  Rfq toEntity() => Rfq(
    title: title,
    description: description,
    clientId: clientId,
    categoryNames: categoryNames,
    budget: budget,
    biddingDeadline: biddingDeadline,
    deliveryDeadline: deliveryDeadline,
    location: location,
    quantity: quantity,
    specification: specification,
    attachments: attachments,
    currentlySelectedBidId: currentlySelectedBidId,
  );

  /// Convert entity to model
  factory RfqModel.fromEntity(Rfq entity) => RfqModel(
    title: entity.title,
    description: entity.description,
    clientId: entity.clientId,
    categoryNames: entity.categoryNames,
    budget: entity.budget,
    biddingDeadline: entity.biddingDeadline,
    deliveryDeadline: entity.deliveryDeadline,
    location: entity.location,
    quantity: entity.quantity,
    specification: entity.specification,
    attachments: entity.attachments,
    currentlySelectedBidId: entity.currentlySelectedBidId,
  );
}