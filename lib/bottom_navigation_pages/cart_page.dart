import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../const/price_descrption_list.dart';
import '../const/titles.dart';
import '../final_pages/billing_address.dart';
import '../home_page/item_details_page.dart';
import '../model/cart_model.dart';
import '../provider/meal_details_provider.dart';

class CartPage extends StatelessWidget {
  final List<CartItem> cartItems;

  CartPage({required this.cartItems});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MealProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                    padding: EdgeInsets.only(left: 90),
                    child: Text(
                      cartTitle,
                      style: TextStyle(
                        fontSize: 27,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: Consumer<MealProvider>(
                builder: (context, mealProvider, _) {
                  var cartItems = mealProvider.cartItems;
                  return ListView.separated(
                    itemCount: cartItems.length,
                    separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Divider(
                        height: 1,
                        color: Colors.red[400],
                        thickness: 1,
                      ),
                    ),
                    itemBuilder: (context, index) {
                      var cartItem = cartItems[index];
                      return ListTile(
                        leading: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemDetailsPage(
                                  name: cartItem.name,
                                  price: dollerPrice[index],
                                  price1: provider
                                      .getTotalPrice1(index)
                                      .toString(),
                                  quantity:
                                  provider.getQuantity(index),
                                  description: description[index],
                                  imageUrl: cartItem.imageUrl,
                                ),
                              ),
                            );
                          },
                          child: Image.network(
                            cartItem.imageUrl,
                            width: 70,
                            height: 70,
                          ),
                        ),
                        title: Text(
                          cartItem.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Text(
                          '\$ ${cartItem.totalItemPrice}',
                          style: TextStyle(
                              color: Colors.red[400],
                              fontWeight: FontWeight.bold),
                        ),
                        trailing: SizedBox(
                          width: 115,
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8BBD0),
                                  borderRadius: BorderRadius.circular(30),
                                  border:
                                      Border.all(color: const Color(0xFFC5CAE9)),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (cartItem.quantity > 1) {
                                          mealProvider
                                              .decrementQuantity(cartItem);
                                        } else {
                                          mealProvider.deleteCartItem(cartItem);
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.remove_circle,
                                        size: 35,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '${cartItem.quantity}',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        mealProvider.incrementQuantity(cartItem);
                                      },
                                      icon: Icon(
                                        Icons.add_circle,
                                        size: 35,
                                        color: Colors.red[400],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // IconButton(
                              //   onPressed: () {
                              //     /// Call the deleteCartItem function and pass the cartItem to delete
                              //     Provider.of<MealProvider>(context,
                              //             listen: false)
                              //         .deleteCartItem(cartItem);
                              //   },
                              //   icon: const Icon(Icons.delete),
                              //   color: Colors.red,
                              // ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    color: Colors.white,
                  )
                ],
                // color: Colors.red[200],
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: const Color(0xFFF8BBD0)),
              ),
              child: const Center(
                child: Text(
                  cartCoupon,
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.normal),
                ),
              ),
            ),
            Divider(
              height: 70,
              color: Colors.red[100],
              thickness: 1,
              indent: 10,
              endIndent: 10,
            ),
            Consumer<MealProvider>(
              builder: (context, mealProvider, _) {
                var itemTotal = mealProvider.calculateItemTotal();
                var tax = 2.95;
                var deliveryFees = 2.25;
                var total = itemTotal + tax + deliveryFees;
                return Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            cartItemTotal,
                            style: TextStyle(color: Colors.black38),
                          ),
                          Text('\$ ${itemTotal.toStringAsFixed(2)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              cartDeliveryFee,
                              style: TextStyle(color: Colors.black38),
                            ),
                            Text('\$ ${deliveryFees.toStringAsFixed(2)}',
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            cartTax,
                            style: TextStyle(color: Colors.black38),
                          ),
                          Text('\$ ${tax.toStringAsFixed(2)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              cartTotal,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            Text('\$ ${total.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[400],
                                    fontSize: 20)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 50,
                right: 20,
                left: 20,
              ),
              padding: const EdgeInsets.only(top: 18, bottom: 18),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 5,
                    color: Colors.grey,
                  )
                ],
                color: Colors.red[400],
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: const Color(0xFFF8BBD0)),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          OrderConfirmationPage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
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
                },
                child: const Center(
                  child: Text(
                    cartConfirm,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.normal,fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
