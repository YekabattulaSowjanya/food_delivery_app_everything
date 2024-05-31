import 'package:flutter/material.dart';
import 'package:food_delivery_app/bottom_navigation_pages/profile_screen.dart';
import 'package:food_delivery_app/const/titles.dart';
import 'package:food_delivery_app/sqlite/user_model.dart';
import 'package:provider/provider.dart';
import '../provider/meal_details_provider.dart';
import '../bottom_navigation_pages/cart_page.dart';
import '../bottom_navigation_pages/favorite_page.dart';
import '../sqlite/billing_model.dart';
import 'home_screen_api_call.dart';
import 'package:badges/badges.dart';

class FirstHomeScreen extends StatelessWidget {
  final User user;
  final UserInfo? userInfo;
  const FirstHomeScreen({
    Key? key,
    required this.user,
    this.userInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('build');
    var provider = Provider.of<MealProvider>(context, listen: false);
    provider.fetchCanadianMeals();
    debugPrint(('email 1:${user.email} '));
    provider.getUserInfo(user.email);
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          elevation: 10,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_filled,
                color:
                    provider.selectedIndex == 0 ? Colors.red[400] : Colors.grey,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline,
                color:
                    provider.selectedIndex == 1 ? Colors.red[400] : Colors.grey,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  Icon(
                    Icons.favorite,
                    color: provider.selectedIndex == 2
                        ? Colors.red[400]
                        : Colors.grey,
                  ),
                  Positioned(
                    top: -8,
                    right: -4,
                    child: Consumer<MealProvider>(
                      builder: (context, provider, _) {
                        int favoriteCount = provider.getFavoriteMeals().length;
                        return favoriteCount > 0
                            ? Badge(
                                badgeContent: Text(
                                  favoriteCount.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                badgeColor: Colors.red[400]!,
                                animationType: BadgeAnimationType.scale,
                                animationDuration: Duration(milliseconds: 300),
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
              label: '',
            ),
          ],
          onTap: (index) {
            debugPrint(('atEmail:${user.email} '));
            if (index == 1) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      ProfilePage(
                    user: user,
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(0.0, 1.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                        position: offsetAnimation, child: child);
                  },
                ),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      FavoritePage(favoriteMeals: provider.getFavoriteMeals()),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(0.0, 1.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;
                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                        position: offsetAnimation, child: child);
                  },
                ),
              );
            } else {
              provider.setSelectedIndex(index);
            }
          },
        ),
        floatingActionButton: Builder(builder: (context) {
          var cartItemsProvider =
              Provider.of<MealProvider>(context, listen: false);

          return Consumer<MealProvider>(
            builder: (context, provider, _) {
              var cartItemCount = cartItemsProvider.cartItems.length;

              return cartItemCount > 0
                  ? Badge(
                      badgeContent: Text(
                        cartItemCount.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      badgeColor: Colors.red,
                      position: BadgePosition.topEnd(top: -6, end: -6),
                      animationDuration: const Duration(milliseconds: 300),
                      animationType: BadgeAnimationType.slide,
                      child: FloatingActionButton(
                        onPressed: () async {
                          var updatedCartItems = await Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation,
                                      secondaryAnimation) =>
                                  CartPage(
                                      cartItems: cartItemsProvider.cartItems),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(0.0, 1.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                    position: offsetAnimation, child: child);
                              },
                            ),
                          );

                          if (updatedCartItems != null) {
                            cartItemsProvider.addToCart(updatedCartItems);
                          }
                        },
                        backgroundColor: Colors.greenAccent,
                        child: const Icon(Icons.shopping_cart,
                            color: Colors.white),
                      ),
                    )
                  : FloatingActionButton(
                      onPressed: () async {
                        var updatedCartItems = await Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation,
                                    secondaryAnimation) =>
                                CartPage(
                                    cartItems: cartItemsProvider.cartItems),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(0.0, 1.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                  position: offsetAnimation, child: child);
                            },
                          ),
                        );

                        if (updatedCartItems != null) {
                          cartItemsProvider.addToCart(updatedCartItems);
                        }
                      },
                      backgroundColor: Colors.greenAccent,
                      child:
                          const Icon(Icons.shopping_cart, color: Colors.white),
                    );
            },
          );
        }),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
                  padding: const EdgeInsets.only(
                      top: 20, left: 20, right: 15, bottom: 10),
                  decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color: Colors.grey,
                        )
                      ],
                      color: Color(0xFFF8BBD0),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(40),
                          bottomLeft: Radius.circular(40))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.dashboard_rounded,
                                size: 25,
                                color: Colors.black,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 5,
                                      color: Colors.grey,
                                    )
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Text(
                                title,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.notifications_none_outlined,
                                size: 25,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 50, bottom: 8),
                          child: Center(
                            child: Text(
                              subTitle1,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 40),
                          child: Center(
                            child: Text(
                              subTitle2,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ])),
              const SizedBox(
                height: 15,
              ),
              HomeScreenApi(),
            ]),
          ),
        ));
  }
}
