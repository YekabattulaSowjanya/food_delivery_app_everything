import 'package:flutter/material.dart';
import 'package:food_delivery_app/sqlite/billing_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/api_model.dart';
import '../model/cart_model.dart';
import '../sqlite/helper.dart';
import 'package:food_delivery_app/const/price_descrption_list.dart';

class MealProvider with ChangeNotifier {
  ///password hide
  bool _passwordVisible = false;

  bool get passwordVisible => _passwordVisible;

  void togglePasswordVisibility() {
    print('Toggling password visibility');
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  ///email profile

  UserInfo? userInfo;
  Future<void> getUserInfo(String emailAddress) async {
    userInfo = (await DatabaseHelper().getUserInfoByEmail(emailAddress));
    debugPrint(('email userInfo:${userInfo?.email} '));
    notifyListeners();
  }

  /// bottom sheet
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    if (index != _selectedIndex) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  ///cart provider
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(CartItem item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  void incrementQuantity(CartItem item) {
    item.quantity++;
    item.totalItemPrice = item.quantity * double.parse(item.price);
    notifyListeners();
  }

  void decrementQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
      item.totalItemPrice = item.quantity * double.parse(item.price);
      notifyListeners();
    }
  }

  double calculateItemTotal() {
    double total = 0;
    for (var item in _cartItems) {
      total += item.totalItemPrice;
    }
    return total;
  }

  void deleteCartItem(CartItem item) {
    cartItems.remove(item);
    notifyListeners();
  }

  ///http

  List<Meals>? _meals;

  List<Meals>? get meals => _meals;

  Future<List<Meals>> fetchCanadianMeals() async {
    final url = 'https://www.themealdb.com/api/json/v1/1/filter.php?a=Canadian';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] != null) {
        final meals = List.from(data['meals'])
            .map((mealJson) => Meals.fromJson(mealJson))
            .toList();
        _meals = meals;
        notifyListeners();
        return meals;
      }
    }
    throw Exception('Failed to fetch data');
  }

  ///favourite icon

  bool _isFavorite = false;

  bool get isFavorite => _isFavorite;

  bool _showBadge = false;

  bool get showBadge => _showBadge;

  void toggleFavorite(Meals meal) {
    meal.isFavorite = !meal.isFavorite;
    _showBadge = meals!.any((meal) => meal.isFavorite);
    notifyListeners();
  }

  List<Meals> getFavoriteMeals() {
    return meals?.where((meal) => meal.isFavorite).toList() ?? [];
  }

  ///+ visiblity

  Map<int, int> _quantities = {};
  Map<int, bool> _isMinusIconVisibleMap = {};
  int getQuantity(int index) {
    return _quantities[index] ?? 1;
  }

  bool isMinusIconVisible1(int index) {
    return _isMinusIconVisibleMap[index] ?? false;
  }

  double getTotalPrice1(int index) {
    double price = double.parse(dollerPrice[index].substring(1));
    double totalPrice = price * getQuantity(index);
    return totalPrice;
  }

  void incrementQuantity2(int index) {
    _quantities[index] = (getQuantity(index) ?? 1) + 1;
    _isMinusIconVisibleMap[index] = true;
    notifyListeners();
  }

  void decrementQuantity3(int index) {
    int currentQuantity = getQuantity(index) ?? 1;
    if (currentQuantity > 1) {
      _quantities[index] = currentQuantity - 1;
      _isMinusIconVisibleMap[index] = true;
    } else {
      _isMinusIconVisibleMap[index] = false;
      _quantities[index] = 1;
    }
    notifyListeners();
  }
}
