class TradeModel {
  final String loopId;
  final List<TradeParticipant> participants;
  final String status; // pending, confirmed, executing, completed, failed, cancelled
  final DateTime createdAt;
  final DateTime? completedAt;
  final List<CreditMovement> creditMovements;

  TradeModel({
    required this.loopId,
    required this.participants,
    this.status = 'pending',
    DateTime? createdAt,
    this.completedAt,
    this.creditMovements = const [],
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'loopId': loopId,
      'participants': participants.map((p) => p.toMap()).toList(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'creditMovements': creditMovements.map((c) => c.toMap()).toList(),
    };
  }

  factory TradeModel.fromMap(Map<String, dynamic> map) {
    return TradeModel(
      loopId: map['loopId'] ?? '',
      participants: (map['participants'] as List<dynamic>?)
              ?.map((p) => TradeParticipant.fromMap(p))
              .toList() ??
          [],
      status: map['status'] ?? 'pending',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'])
          : null,
      creditMovements: (map['creditMovements'] as List<dynamic>?)
              ?.map((c) => CreditMovement.fromMap(c))
              .toList() ??
          [],
    );
  }

  TradeModel copyWith({
    String? loopId,
    List<TradeParticipant>? participants,
    String? status,
    DateTime? createdAt,
    DateTime? completedAt,
    List<CreditMovement>? creditMovements,
  }) {
    return TradeModel(
      loopId: loopId ?? this.loopId,
      participants: participants ?? this.participants,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      creditMovements: creditMovements ?? this.creditMovements,
    );
  }
}

class TradeParticipant {
  final String farmerId;
  final String farmerName;
  final String listingId;
  final String offerProduct;
  final String wantProduct;
  final double offerQuantity;
  final String unit;
  final double valuationAmount;
  final String confirmationStatus; // pending, confirmed, declined

  TradeParticipant({
    required this.farmerId,
    required this.farmerName,
    required this.listingId,
    required this.offerProduct,
    required this.wantProduct,
    required this.offerQuantity,
    required this.unit,
    this.valuationAmount = 0.0,
    this.confirmationStatus = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'farmerId': farmerId,
      'farmerName': farmerName,
      'listingId': listingId,
      'offerProduct': offerProduct,
      'wantProduct': wantProduct,
      'offerQuantity': offerQuantity,
      'unit': unit,
      'valuationAmount': valuationAmount,
      'confirmationStatus': confirmationStatus,
    };
  }

  factory TradeParticipant.fromMap(Map<String, dynamic> map) {
    return TradeParticipant(
      farmerId: map['farmerId'] ?? '',
      farmerName: map['farmerName'] ?? '',
      listingId: map['listingId'] ?? '',
      offerProduct: map['offerProduct'] ?? '',
      wantProduct: map['wantProduct'] ?? '',
      offerQuantity: (map['offerQuantity'] ?? 0.0).toDouble(),
      unit: map['unit'] ?? 'kg',
      valuationAmount: (map['valuationAmount'] ?? 0.0).toDouble(),
      confirmationStatus: map['confirmationStatus'] ?? 'pending',
    );
  }
}

class CreditMovement {
  final String fromUserId;
  final String toUserId;
  final double amount;
  final String description;

  CreditMovement({
    required this.fromUserId,
    required this.toUserId,
    required this.amount,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'amount': amount,
      'description': description,
    };
  }

  factory CreditMovement.fromMap(Map<String, dynamic> map) {
    return CreditMovement(
      fromUserId: map['fromUserId'] ?? '',
      toUserId: map['toUserId'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      description: map['description'] ?? '',
    );
  }
}
