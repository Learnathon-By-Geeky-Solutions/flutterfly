// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rfq_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rfq _$RfqFromJson(Map<String, dynamic> json) => Rfq(
      title: json['title'] as String,
      description: json['description'] as String,
      clientId: json['clientId'] as String,
      categoryNames: (json['categoryNames'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      budget: json['budget'] as num,
      biddingDeadline: DateTime.parse(json['biddingDeadline'] as String),
      deliveryDeadline: json['deliveryDeadline'] == null
          ? null
          : DateTime.parse(json['deliveryDeadline'] as String),
      location: json['location'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      specification: (json['specification'] as List<dynamic>?)
          ?.map((e) => Map<String, String>.from(e as Map))
          .toList(),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      currentlySelectedBidId: json['currentlySelectedBidId'] as String?,
    );

Map<String, dynamic> _$RfqToJson(Rfq instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'clientId': instance.clientId,
      'categoryNames': instance.categoryNames,
      'budget': instance.budget,
      'biddingDeadline': instance.biddingDeadline.toIso8601String(),
      'deliveryDeadline': instance.deliveryDeadline?.toIso8601String(),
      'location': instance.location,
      'quantity': instance.quantity,
      'specification': instance.specification,
      'attachments': instance.attachments,
      'currentlySelectedBidId': instance.currentlySelectedBidId,
    };
