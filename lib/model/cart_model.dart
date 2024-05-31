class CartItem {
  final String name;
  final String price;
   int quantity;
  final String imageUrl;
   double totalItemPrice;

  CartItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.totalItemPrice,
  });
}

List<CartItem> cartItems = [];
