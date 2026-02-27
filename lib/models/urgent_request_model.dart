class UrgentRequestModel {
  final String id;
  final String requesterId;
  final String requesterName;
  final String requesterVillage;
  final String productNeeded;
  final double quantity;
  final String unit;
  final double creditCost; // How many credits the requester pays
  final String urgencyLevel; // 'high', 'medium', 'low'
  final String description;
  final String status; // 'open', 'accepted', 'completed', 'cancelled'
  final String? fulfillerId;
  final String? fulfillerName;
  final DateTime createdAt;
  final DateTime? fulfilledAt;

  UrgentRequestModel({
    required this.id,
    required this.requesterId,
    required this.requesterName,
    required this.requesterVillage,
    required this.productNeeded,
    required this.quantity,
    required this.unit,
    required this.creditCost,
    this.urgencyLevel = 'high',
    this.description = '',
    this.status = 'open',
    this.fulfillerId,
    this.fulfillerName,
    DateTime? createdAt,
    this.fulfilledAt,
  }) : createdAt = createdAt ?? DateTime.now();

  UrgentRequestModel copyWith({
    String? status,
    String? fulfillerId,
    String? fulfillerName,
    DateTime? fulfilledAt,
  }) {
    return UrgentRequestModel(
      id: id,
      requesterId: requesterId,
      requesterName: requesterName,
      requesterVillage: requesterVillage,
      productNeeded: productNeeded,
      quantity: quantity,
      unit: unit,
      creditCost: creditCost,
      urgencyLevel: urgencyLevel,
      description: description,
      status: status ?? this.status,
      fulfillerId: fulfillerId ?? this.fulfillerId,
      fulfillerName: fulfillerName ?? this.fulfillerName,
      createdAt: createdAt,
      fulfilledAt: fulfilledAt ?? this.fulfilledAt,
    );
  }
}
