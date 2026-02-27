class ListingModel {
  final String id;
  final String farmerId;
  final String farmerName;
  final String farmerVillage;
  final String productType;
  final double quantity;
  final String unit;
  final String qualityExpectation; // Excellent, Good, Average
  final String desiredProduct;
  final double valuationScore;
  final DateTime expiryTime;
  final double latitude;
  final double longitude;
  final String? imageUrl;
  final String status; // active, locked, completed, expired
  final DateTime createdAt;

  ListingModel({
    required this.id,
    required this.farmerId,
    required this.farmerName,
    required this.farmerVillage,
    required this.productType,
    required this.quantity,
    required this.unit,
    this.qualityExpectation = 'Good',
    required this.desiredProduct,
    this.valuationScore = 0.0,
    DateTime? expiryTime,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.imageUrl,
    this.status = 'active',
    DateTime? createdAt,
  })  : expiryTime = expiryTime ?? DateTime.now().add(const Duration(days: 7)),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'farmerId': farmerId,
      'farmerName': farmerName,
      'farmerVillage': farmerVillage,
      'productType': productType,
      'quantity': quantity,
      'unit': unit,
      'qualityExpectation': qualityExpectation,
      'desiredProduct': desiredProduct,
      'valuationScore': valuationScore,
      'expiryTime': expiryTime.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ListingModel.fromMap(Map<String, dynamic> map) {
    return ListingModel(
      id: map['id'] ?? '',
      farmerId: map['farmerId'] ?? '',
      farmerName: map['farmerName'] ?? '',
      farmerVillage: map['farmerVillage'] ?? '',
      productType: map['productType'] ?? '',
      quantity: (map['quantity'] ?? 0.0).toDouble(),
      unit: map['unit'] ?? 'kg',
      qualityExpectation: map['qualityExpectation'] ?? 'Good',
      desiredProduct: map['desiredProduct'] ?? '',
      valuationScore: (map['valuationScore'] ?? 0.0).toDouble(),
      expiryTime: map['expiryTime'] != null
          ? DateTime.parse(map['expiryTime'])
          : DateTime.now().add(const Duration(days: 7)),
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'],
      status: map['status'] ?? 'active',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  ListingModel copyWith({
    String? id,
    String? farmerId,
    String? farmerName,
    String? farmerVillage,
    String? productType,
    double? quantity,
    String? unit,
    String? qualityExpectation,
    String? desiredProduct,
    double? valuationScore,
    DateTime? expiryTime,
    double? latitude,
    double? longitude,
    String? imageUrl,
    String? status,
    DateTime? createdAt,
  }) {
    return ListingModel(
      id: id ?? this.id,
      farmerId: farmerId ?? this.farmerId,
      farmerName: farmerName ?? this.farmerName,
      farmerVillage: farmerVillage ?? this.farmerVillage,
      productType: productType ?? this.productType,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      qualityExpectation: qualityExpectation ?? this.qualityExpectation,
      desiredProduct: desiredProduct ?? this.desiredProduct,
      valuationScore: valuationScore ?? this.valuationScore,
      expiryTime: expiryTime ?? this.expiryTime,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
