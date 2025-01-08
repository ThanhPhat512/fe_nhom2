class FoodItem {
  final int fdcId;
  final String description;
  final String imageUrl;
  final String dataType;
  final String publicationDate;
  final String foodCode;

  FoodItem({
    required this.fdcId,
    required this.description,
    required this.imageUrl,
    required this.dataType,
    required this.publicationDate,
    required this.foodCode,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      fdcId: json['fdcId'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      dataType: json['dataType'],
      publicationDate: json['publicationDate'],
      foodCode: json['foodCode'],
    );
  }

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
