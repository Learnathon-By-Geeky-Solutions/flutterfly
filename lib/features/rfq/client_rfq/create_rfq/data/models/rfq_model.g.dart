// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rfq_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RfqModel _$RfqModelFromJson(Map<String, dynamic> json) => RfqModel(
      title: json['title'] as String,
      description: json['description'] as String,
      clientId: json['client_id'] as String,
      categoryNames: (json['category_names'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      budget: json['budget'] as num,
      biddingDeadline: DateTime.parse(json['bidding_deadline'] as String),
      deliveryDeadline: json['delivery_deadline'] == null
          ? null
          : DateTime.parse(json['delivery_deadline'] as String),
      location: json['location'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      specification: (json['specification'] as List<dynamic>?)
          ?.map((e) => Map<String, String>.from(e as Map))
          .toList(),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      currentlySelectedBidId: json['currently_selected_bid_id'] as String?,
    );

Map<String, dynamic> _$RfqModelToJson(RfqModel instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'client_id': instance.clientId,
      'category_names': instance.categoryNames,
      'budget': instance.budget,
      'bidding_deadline': instance.biddingDeadline.toIso8601String(),
      'delivery_deadline': instance.deliveryDeadline?.toIso8601String(),
      'location': instance.location,
      'quantity': instance.quantity,
      'specification': instance.specification,
      'attachments': instance.attachments,
      'currently_selected_bid_id': instance.currentlySelectedBidId,
    };
