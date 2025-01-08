class FoodDetail {
  final int fdcId;
  final String description;
  final String imageUrl;
  final String dataType;
  final String publicationDate;
  final String foodCode;
  final List<FoodNutrient> foodNutrients;

  FoodDetail({
    required this.fdcId,
    required this.description,
    required this.imageUrl,
    required this.dataType,
    required this.publicationDate,
    required this.foodCode,
    required this.foodNutrients,
  });

  // Factory để parse JSON thành FoodDetail
  factory FoodDetail.fromJson(Map<String, dynamic> json) {
    return FoodDetail(
      fdcId: json['fdcId'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      dataType: json['dataType'],
      publicationDate: json['publicationDate'],
      foodCode: json['foodCode'],
      foodNutrients: (json['foodNutrients'] as List)
          .map((item) => FoodNutrient.fromJson(item))
          .toList(),
    );
  }
}

class FoodNutrient {
  final int id;
  final double amount;
  final Nutrient nutrient;

  FoodNutrient({
    required this.id,
    required this.amount,
    required this.nutrient,
  });

  // Factory để parse JSON thành FoodNutrient
  factory FoodNutrient.fromJson(Map<String, dynamic> json) {
    return FoodNutrient(
      id: json['id'],
      amount: json['amount'] ?? 0.0,
      nutrient: Nutrient.fromJson(json['nutrient']),
    );
  }
}

class Nutrient {
  final int id;
  final int number;
  final String name;
  final String unitName;

  Nutrient({
    required this.id,
    required this.number,
    required this.name,
    required this.unitName,
  });

  // Factory để parse JSON thành Nutrient
  factory Nutrient.fromJson(Map<String, dynamic> json) {
    return Nutrient(
      id: json['id'],
      number: json['number'],
      name: json['name'],
      unitName: json['unitName'],
    );
  }
}
