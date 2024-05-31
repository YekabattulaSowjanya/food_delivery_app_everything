import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../const/price_descrption_list.dart';
import '../const/titles.dart';
import '../provider/meal_details_provider.dart';
import 'item_details_page.dart';

class HomeScreenApi extends StatelessWidget {
  const HomeScreenApi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 15,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 23, fontWeight: FontWeight.bold),
            ),
          ),
          Consumer<MealProvider>(builder: (context, provider, _) {
            if (provider.meals == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (provider.meals!.isEmpty) {
              return const Center(
                child: Text('No data available'),
              );
            } else {
              return GridView.builder(
                itemCount: provider.meals!.length, //4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.78,
                ),
                itemBuilder: (context, index) {
                  final meal = provider.meals![index];

                  ///list pf price
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
                      border:
                      Border.all(color: const Color(0xFFC5CAE9)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 100),
                          child: GestureDetector(
                            onTap: () {
                              debugPrint(
                                  'fav: ${provider.isFavorite}');
                              provider.toggleFavorite(meal);
                              debugPrint(
                                  'fav after: ${provider.isFavorite}');
                            },
                            child: Icon(
                              meal.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: meal.isFavorite
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemDetailsPage(
                                  name: meal.strMeal ?? '',
                                  price: dollerPrice[index],
                                  price1: provider
                                      .getTotalPrice1(index)
                                      .toString(),
                                  quantity:
                                  provider.getQuantity(index),
                                  description: description[index],
                                  imageUrl: meal.strMealThumb ?? '',
                                ),
                              ),
                            );
                          },
                          child: CachedNetworkImage(
                            imageUrl: meal.strMealThumb ?? '',
                            height: 90,
                            width: 100,
                            placeholder: (context, url) =>
                            const CircularProgressIndicator(), // Placeholder while loading
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                          ),
                        ),
                        Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, bottom: 5),
                              child: Text(
                                meal.strMeal ?? '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                            Text(meal.idMeal ?? ''),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 5, top: 10),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${provider.getTotalPrice1(index).toStringAsFixed(2)}', //price[index],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () => provider
                                            .incrementQuantity2(
                                            index),
                                        child: Container(
                                          padding:
                                          const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            color: Colors.red[400],
                                            borderRadius:
                                            BorderRadius.circular(
                                                16),
                                          ),
                                          child: const Icon(
                                            Icons.add,
                                            size: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(
                                            left: 2.0, right: 4),
                                        child: Text(
                                          ' ${provider.getQuantity(index)}',
                                          style: TextStyle(
                                            /// Show/hide text color based on visibility
                                            color: provider
                                                .isMinusIconVisible1(
                                                index)
                                                ? Colors
                                                .black // Show text
                                                : Colors
                                                .transparent, // Hide text
                                          ),
                                        ),
                                      ),
                                      if (provider
                                          .isMinusIconVisible1(index))
                                        InkWell(
                                          onTap: () => provider
                                              .decrementQuantity3(
                                              index),
                                          child: Container(
                                            padding:
                                            const EdgeInsets.all(
                                                3),
                                            decoration: BoxDecoration(
                                              color: Colors.red[400],
                                              borderRadius:
                                              BorderRadius
                                                  .circular(16),
                                            ),
                                            child: const Icon(
                                              Icons.remove,
                                              size: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                    ],
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
              );
            }
          }),
        ],
      ),
    );
  }
}
