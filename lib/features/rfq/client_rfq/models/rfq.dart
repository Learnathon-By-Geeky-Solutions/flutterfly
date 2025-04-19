class Rfq {
  final String title;
  final String description;
  final String clientId;
  final String categoryId;
  final num? minBudget;
  final num? maxBudget;
  final DateTime rfqDeadline;
  final DateTime? deliveryDeadline;
  final String? location;
  final int? quantity;
  final List<String>? specification;
  final List<String>? attachments;
  final String? currently_selected_bid_id;

  Rfq({
    required this.title,
    required this.description,
    required this.clientId,
    required this.categoryId,
    this.minBudget,
    this.maxBudget,
    required this.rfqDeadline,
    this.deliveryDeadline,
    this.location,
    this.quantity,
    this.specification,
    this.attachments,
    this.currently_selected_bid_id,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'client_id': clientId,
    'category_id': categoryId,
    'min_budget': minBudget,
    'max_budget': maxBudget,
    'rfq_deadline': rfqDeadline.toIso8601String(),
    'delivery_deadline': deliveryDeadline?.toIso8601String(),
    'location': location,
    'quantity': quantity,
    'specification': specification,
    'attachments': attachments,
    'currently_selected_bid_id': currently_selected_bid_id
  };

  /// Convert a Supabase row (map) into an Rfq instance
  factory Rfq.fromJson(Map<String, dynamic> json) {
    // Supabase returns timestamps as ISO‐8601 strings
    DateTime parseTs(dynamic v) =>
        v is String ? DateTime.parse(v) : (v as DateTime);

    return Rfq(
      title: json['title'] as String,
      description: json['description'] as String,
      clientId: json['client_id'] as String,
      categoryId: json['category_id'] as String,
      minBudget: json['min_budget'] as num?,
      maxBudget: json['max_budget'] as num?,
      rfqDeadline: parseTs(json['rfq_deadline']),
      deliveryDeadline:
      json['delivery_deadline'] != null ? parseTs(json['delivery_deadline']) : null,
      location: json['location'] as String?,
      quantity: json['quantity'] as int?,
      specification: (json['specification'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [],
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [],
      currently_selected_bid_id: json['currently_selected_bid_id'] as String?,
    );
  }
}