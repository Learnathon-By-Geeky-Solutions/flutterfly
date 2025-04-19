// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rfq_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RfqModel _$RfqModelFromJson(Map<String, dynamic> json) => RfqModel(
      title: json['title'] as String,
      description: json['description'] as String,
      clientId: json['client_id'] as String,
      categoryId: json['category_id'] as String,
      minBudget: json['min_budget'] as num?,
      maxBudget: json['max_budget'] as num?,
      biddingDeadline: DateTime.parse(json['bidding_deadline'] as String),
      deliveryDeadline: json['delivery_deadline'] == null
          ? null
          : DateTime.parse(json['delivery_deadline'] as String),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$RfqModelToJson(RfqModel instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'client_id': instance.clientId,
      'category_id': instance.categoryId,
      'min_budget': instance.minBudget,
      'max_budget': instance.maxBudget,
      'bidding_deadline': instance.biddingDeadline.toIso8601String(),
      'delivery_deadline': instance.deliveryDeadline?.toIso8601String(),
      'attachments': instance.attachments,
    };
