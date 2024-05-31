import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/const/price_descrption_list.dart';
import 'package:provider/provider.dart';
import '../const/titles.dart';
import '../home_page/item_details_page.dart';
import '../model/api_model.dart';
import '../provider/meal_details_provider.dart';

class FavoritePage extends StatelessWidget {
  final List<Meals> favoriteMeals;

  FavoritePage({required this.favoriteMeals});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MealProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                   const Padding(
                    padding: EdgeInsets.only(left: 60),
                    child: Text(
                      favorite,
                      style: TextStyle(
                        fontSize: 27,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(left: 20, right: 20),
                itemCount: favoriteMeals.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final meal = favoriteMeals[index];

                  ///list of price
                  return Container(
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 3,
                            color: Colors.grey,
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFC5CAE9))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CachedNetworkImage(
                          imageUrl: meal.strMealThumb ?? '',
                          height: 70,
                          width: 80,
                          placeholder: (context, url) => CircularProgressIndicator(), // Placeholder while loading
                          errorWidget: (context, url, error) => Icon(Icons.error), // Error placeholder
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text(
                                meal.strMeal ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(meal.idMeal ?? ''),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    dollerPrice[index],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ItemDetailsPage(
                                            name: meal.strMeal ?? '',
                                            price1: provider.getTotalPrice1(index).toString(),
                                            quantity: provider.getQuantity(index),
                                            price: dollerPrice[index],
                                            description: description[index],
                                            imageUrl: meal.strMealThumb ?? '',
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: Colors.red[400],
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
