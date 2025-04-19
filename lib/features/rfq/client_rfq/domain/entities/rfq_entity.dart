class Rfq {
  final String title;
  final String description;
  final String clientId;
  final String categoryId;
  final num? minBudget;
  final num? maxBudget;
  final DateTime biddingDeadline;
  final DateTime? deliveryDeadline;
  final String? location;
  final int? quantity;
  final List<String>? specification;
  final List<String>? attachments;
  final String? currentlySelectedBidId;

  Rfq({
    required this.title,
    required this.description,
    required this.clientId,
    required this.categoryId,
    this.minBudget,
    this.maxBudget,
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
    String? categoryId,
    num? minBudget,
    num? maxBudget,
    DateTime? biddingDeadline,
    DateTime? deliveryDeadline,
    String? location,
    int? quantity,
    List<String>? specification,
    List<String>? attachments,
    String? currentlySelectedBidId,
  }) {
    return Rfq(
      title: title ?? this.title,
      description: description ?? this.description,
      clientId: clientId ?? this.clientId,
      categoryId: categoryId ?? this.categoryId,
      minBudget: minBudget ?? this.minBudget,
      maxBudget: maxBudget ?? this.maxBudget,
      biddingDeadline: biddingDeadline ?? this.biddingDeadline,
      deliveryDeadline: deliveryDeadline ?? this.deliveryDeadline,
      location: location ?? this.location,
      quantity: quantity ?? this.quantity,
      specification: specification ?? this.specification,
      attachments: attachments ?? this.attachments,
      currentlySelectedBidId: currentlySelectedBidId ?? this.currentlySelectedBidId,
    );
  }
}