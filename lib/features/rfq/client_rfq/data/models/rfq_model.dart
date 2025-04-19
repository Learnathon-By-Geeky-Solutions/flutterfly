import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/rfq_entity.dart';

part 'rfq_model.g.dart';

@JsonSerializable()
class RfqModel {
  final String title;
  final String description;
  @JsonKey(name: 'client_id')
  final String clientId;
  @JsonKey(name: 'category_id')
  final String categoryId;
  @JsonKey(name: 'min_budget')
  final num? minBudget;
  @JsonKey(name: 'max_budget')
  final num? maxBudget;
  @JsonKey(name: 'bidding_deadline')
  final DateTime biddingDeadline;
  @JsonKey(name: 'delivery_deadline')
  final DateTime? deliveryDeadline;
  final List<String>? attachments;

  const RfqModel({
    required this.title,
    required this.description,
    required this.clientId,
    required this.categoryId,
    this.minBudget,
    this.maxBudget,
    required this.biddingDeadline,
    this.deliveryDeadline,
    this.attachments,
  });

  factory RfqModel.fromJson(Map<String, dynamic> json) => _$RfqModelFromJson(json);
  Map<String, dynamic> toJson() => _$RfqModelToJson(this);

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