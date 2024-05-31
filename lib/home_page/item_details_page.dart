import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../const/titles.dart';
import '../model/cart_model.dart';
import '../provider/meal_details_provider.dart';

class ItemDetailsPage extends StatefulWidget {
  final String name;
  final String price;
  final String description;
  final String imageUrl;
  final String price1;
  final int quantity;

  const ItemDetailsPage({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.price1,
    required this.quantity,
  });

  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  int _quantity = 1;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _quantity = widget.quantity;
  }

  void _increment() {
    setState(() {
      _quantity++;
    });
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _addToCart() {
    /// Get the updated item details (name, price, quantity)
    String itemName = widget.name;
    String itemImageUrl = widget.imageUrl;

    String itemPrice = widget.price.substring(1);
    double parsedItemPrice = double.parse(itemPrice);

    int itemQuantity = _quantity;

    /// Calculate total price based on the quantity
    double totalItemPrice = parsedItemPrice * _quantity;

    /// Create the item and add it to the cart list
    CartItem newItem = CartItem(
      name: itemName,
      price: itemPrice,
      quantity: itemQuantity,
      imageUrl: itemImageUrl,
      totalItemPrice: totalItemPrice,
    );

    /// Use the MealProvider to add the item to the cart
    var mealProvider = Provider.of<MealProvider>(context, listen: false);
    mealProvider.addToCart(newItem);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: Container(
              height: 350,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  widget.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.fill,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      _isLoading =
                          false;
                      return child;
                    } else {
                      return const Center(
                        child:
                            CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 22, top: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: const Icon(Icons.arrow_back_ios_new),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          // Item details
          Padding(
            padding: const EdgeInsets.only(
                top: 370, bottom: 10, left: 20, right: 22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 3,
                            color: Colors.grey,
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFC5CAE9)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: _decrement,
                            icon: const Icon(Icons.remove),
                          ),
                          Text(
                            _quantity.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          IconButton(
                            onPressed: _increment,
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  "\$${(double.parse(widget.price.substring(1)) * _quantity).toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE57373),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 130),
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 5,
                        color: Colors.grey,
                      )
                    ],
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: const Color(0xFFC5CAE9)),
                  ),
                  child: InkWell(
                    onTap: _addToCart,
                    child: const Center(
                        child: Text(
                      cart,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.normal),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
