class UserModel {
  final String id;
  final String phone;
  final String name;
  final String village;
  final double latitude;
  final double longitude;
  final double reputationScore;
  final double creditBalance;
  final double frozenCredits;
  final String
      verificationStatus; // 'unverified', 'phone_verified', 'aadhaar_verified'
  final String? profileImageUrl;
  final int totalTrades;
  final int disputeCount;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.phone,
    required this.name,
    required this.village,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.reputationScore = 75.0,
    this.creditBalance = 1000.0,
    this.frozenCredits = 0.0,
    this.verificationStatus = 'phone_verified',
    this.profileImageUrl,
    this.totalTrades = 0,
    this.disputeCount = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phone': phone,
      'name': name,
      'village': village,
      'latitude': latitude,
      'longitude': longitude,
      'reputationScore': reputationScore,
      'creditBalance': creditBalance,
      'frozenCredits': frozenCredits,
      'verificationStatus': verificationStatus,
      'profileImageUrl': profileImageUrl,
      'totalTrades': totalTrades,
      'disputeCount': disputeCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      phone: map['phone'] ?? '',
      name: map['name'] ?? '',
      village: map['village'] ?? '',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      reputationScore: (map['reputationScore'] ?? 75.0).toDouble(),
      creditBalance: (map['creditBalance'] ?? 1000.0).toDouble(),
      frozenCredits: (map['frozenCredits'] ?? 0.0).toDouble(),
      verificationStatus: map['verificationStatus'] ?? 'phone_verified',
      profileImageUrl: map['profileImageUrl'],
      totalTrades: map['totalTrades'] ?? 0,
      disputeCount: map['disputeCount'] ?? 0,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  UserModel copyWith({
    String? id,
    String? phone,
    String? name,
    String? village,
    double? latitude,
    double? longitude,
    double? reputationScore,
    double? creditBalance,
    double? frozenCredits,
    String? verificationStatus,
    String? profileImageUrl,
    int? totalTrades,
    int? disputeCount,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      village: village ?? this.village,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      reputationScore: reputationScore ?? this.reputationScore,
      creditBalance: creditBalance ?? this.creditBalance,
      frozenCredits: frozenCredits ?? this.frozenCredits,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      totalTrades: totalTrades ?? this.totalTrades,
      disputeCount: disputeCount ?? this.disputeCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
