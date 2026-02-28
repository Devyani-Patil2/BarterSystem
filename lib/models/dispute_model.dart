class DisputeModel {
  final String id;
  final String tradeId;
  final String complainantId;
  final String complainantName;
  final String respondentId;
  final String respondentName;
  final String? complaintPhotoUrl;
  final String? deliveryPhotoUrl;
  final String description;
  final double aiSimilarityScore;
  final String
      aiVerdict; // valid_complaint, partial_refund, full_penalty, false_complaint
  final String
      resolution; // pending, resolved_refund, resolved_penalty, dismissed
  final String status; // open, under_review, resolved, appealed
  final double refundAmount;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  DisputeModel({
    required this.id,
    required this.tradeId,
    required this.complainantId,
    required this.complainantName,
    required this.respondentId,
    required this.respondentName,
    this.complaintPhotoUrl,
    this.deliveryPhotoUrl,
    this.description = '',
    this.aiSimilarityScore = 0.0,
    this.aiVerdict = 'pending',
    this.resolution = 'pending',
    this.status = 'open',
    this.refundAmount = 0.0,
    DateTime? createdAt,
    this.resolvedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tradeId': tradeId,
      'complainantId': complainantId,
      'complainantName': complainantName,
      'respondentId': respondentId,
      'respondentName': respondentName,
      'complaintPhotoUrl': complaintPhotoUrl,
      'deliveryPhotoUrl': deliveryPhotoUrl,
      'description': description,
      'aiSimilarityScore': aiSimilarityScore,
      'aiVerdict': aiVerdict,
      'resolution': resolution,
      'status': status,
      'refundAmount': refundAmount,
      'createdAt': createdAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
    };
  }

  factory DisputeModel.fromMap(Map<String, dynamic> map) {
    return DisputeModel(
      id: map['id'] ?? '',
      tradeId: map['tradeId'] ?? '',
      complainantId: map['complainantId'] ?? '',
      complainantName: map['complainantName'] ?? '',
      respondentId: map['respondentId'] ?? '',
      respondentName: map['respondentName'] ?? '',
      complaintPhotoUrl: map['complaintPhotoUrl'],
      deliveryPhotoUrl: map['deliveryPhotoUrl'],
      description: map['description'] ?? '',
      aiSimilarityScore: (map['aiSimilarityScore'] ?? 0.0).toDouble(),
      aiVerdict: map['aiVerdict'] ?? 'pending',
      resolution: map['resolution'] ?? 'pending',
      status: map['status'] ?? 'open',
      refundAmount: (map['refundAmount'] ?? 0.0).toDouble(),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      resolvedAt:
          map['resolvedAt'] != null ? DateTime.parse(map['resolvedAt']) : null,
    );
  }
}
