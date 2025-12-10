class FavoriteMeal {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;
  final String strCategory;
  final DateTime addedAt;

  FavoriteMeal({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
    required this.strCategory,
    required this.addedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'idMeal': idMeal,
      'strMeal': strMeal,
      'strMealThumb': strMealThumb,
      'strCategory': strCategory,
      'addedAt': addedAt.millisecondsSinceEpoch,
    };
  }

  factory FavoriteMeal.fromMap(Map<String, dynamic> map) {
    return FavoriteMeal(
      idMeal: map['idMeal'] ?? '',
      strMeal: map['strMeal'] ?? '',
      strMealThumb: map['strMealThumb'] ?? '',
      strCategory: map['strCategory'] ?? '',
      addedAt: DateTime.fromMillisecondsSinceEpoch(map['addedAt'] ?? 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMeal': idMeal,
      'strMeal': strMeal,
      'strMealThumb': strMealThumb,
      'strCategory': strCategory,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory FavoriteMeal.fromJson(Map<String, dynamic> json) {
    return FavoriteMeal(
      idMeal: json['idMeal'] ?? '',
      strMeal: json['strMeal'] ?? '',
      strMealThumb: json['strMealThumb'] ?? '',
      strCategory: json['strCategory'] ?? '',
      addedAt: DateTime.parse(json['addedAt']),
    );
  }
}