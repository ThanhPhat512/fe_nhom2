class SeachProduct {
  final int fdcId;
  final String description;
  final String imageUrl;
  final String dataType;
  final String publicationDate;
  final String foodCode;

  SeachProduct({
    required this.fdcId,
    required this.description,
    required this.imageUrl,
    required this.dataType,
    required this.publicationDate,
    required this.foodCode,
  });

  // Factory method to create a FoodItem from JSON
  factory SeachProduct.fromJson(Map<String, dynamic> json) {
    return SeachProduct(
      fdcId: json['fdcId'] ?? 0,
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      dataType: json['dataType'] ?? '',
      publicationDate: json['publicationDate'] ?? '',
      foodCode: json['foodCode'] ?? '',
    );
  }

  // Method to convert FoodItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'fdcId': fdcId,
      'description': description,
      'imageUrl': imageUrl,
      'dataType': dataType,
      'publicationDate': publicationDate,
      'foodCode': foodCode,
    };
  }
}
