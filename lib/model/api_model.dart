class Meals {
  Meals({
    this.strMeal,
    this.strMealThumb,
    this.idMeal,
    this.isFavorite=false,
    this.quantity = 0,
    this.isMinusIconVisible = false,
  }) ;

  Meals.fromJson(dynamic json) {
    strMeal = json['strMeal'];
    strMealThumb = json['strMealThumb'];
    idMeal = json['idMeal'];
    //isFavorite = false;
  }

  String? strMeal;
  String? strMealThumb;
  String? idMeal;
  bool isFavorite= false;
  int quantity=0;
  bool isMinusIconVisible = false;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['strMeal'] = strMeal;
    map['strMealThumb'] = strMealThumb;
    map['idMeal'] = idMeal;
    return map;
  }
}
