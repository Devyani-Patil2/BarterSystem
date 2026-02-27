class CreditTransactionModel {
  final String id;
  final String userId;
  final String? fromUserId;
  final String? toUserId;
  final double amount;
  final String type; // credit, debit, freeze, unfreeze
  final String? tradeId;
  final String description;
  final double balanceAfter;
  final DateTime timestamp;

  CreditTransactionModel({
    required this.id,
    required this.userId,
    this.fromUserId,
    this.toUserId,
    required this.amount,
    required this.type,
    this.tradeId,
    required this.description,
    this.balanceAfter = 0.0,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'amount': amount,
      'type': type,
      'tradeId': tradeId,
      'description': description,
      'balanceAfter': balanceAfter,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory CreditTransactionModel.fromMap(Map<String, dynamic> map) {
    return CreditTransactionModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      fromUserId: map['fromUserId'],
      toUserId: map['toUserId'],
      amount: (map['amount'] ?? 0.0).toDouble(),
      type: map['type'] ?? 'credit',
      tradeId: map['tradeId'],
      description: map['description'] ?? '',
      balanceAfter: (map['balanceAfter'] ?? 0.0).toDouble(),
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
    );
  }
}
