import 'package:flutter/material.dart';
import 'package:finalproject/MainScreen/data.dart';
import 'package:finalproject/MainScreen/order-page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  Map<Book, int> cartItems = CartManager.cartItems;

  void incrementQuantity(Book book) {
    setState(() {
      CartManager.updateQuantity(book, cartItems[book]! + 1);
    });
  }

  void decrementQuantity(Book book) {
    setState(() {
      CartManager.updateQuantity(book, cartItems[book]! - 1);
    });
  }

  void removeItem(Book book) {
    setState(() {
      CartManager.removeItem(book);
    });
  }

  double get totalPrice {
    double total = 0;
    cartItems.forEach((book, quantity) {
      total += book.price * quantity;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) {
      return Scaffold(
        backgroundColor: Color(0xFFFCE8D2),
        appBar: AppBar(
          backgroundColor: Color(0xFFFCE8D2),
          title: Text("Cart"),
          centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.brown[800]),
          titleTextStyle: TextStyle(
              color: Colors.brown[800],
              fontSize: 22,
              fontWeight: FontWeight.bold),
        ),
        body: Center(
          child: Text(
            'Your cart is empty.',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFFCE8D2),
      appBar: AppBar(
        backgroundColor: Color(0xFFFCE8D2),
        title: Text("Cart"),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.brown[800]),
        titleTextStyle: TextStyle(
            color: Colors.brown[800], fontSize: 22, fontWeight: FontWeight.bold),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: cartItems.entries.map((entry) {
                Book book = entry.key;
                int quantity = entry.value;
                return ListTile(
                  leading: Image.asset(book.image,
                      width: 60, height: 60, fit: BoxFit.cover),
                  title: Text(book.title,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('\$${book.price.toStringAsFixed(2)}'),
                  trailing: SizedBox(
                    width: 155,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: () => decrementQuantity(book),
                        ),
                        Text('$quantity', style: TextStyle(fontSize: 16)),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: () => incrementQuantity(book),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => removeItem(book),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.brown.shade100,
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, -2))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: \$${CartManager.totalPrice.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[900]),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (CartManager.cartItems.isNotEmpty) {
                      OrderManager.placeOrder([Map.from(CartManager.cartItems)]);

                      CartManager.clearCart();

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const OrderPage()),
                      );
                    }
                  },
                  child: Text('Place Order', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.brown[800],
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CartManager {
  static final Map<Book, int> _cartItems = {};

  static Map<Book, int> get cartItems => _cartItems;

  static void addToCart(Book book, int quantity) {
    if (quantity == 0) return;

    if (_cartItems.containsKey(book)) {
      _cartItems[book] = _cartItems[book]! + quantity;
    } else {
      _cartItems[book] = quantity;
    }
  }

  static void updateQuantity(Book book, int newQuantity) {
    if (newQuantity <= 0) {
      _cartItems.remove(book);
    } else {
      _cartItems[book] = newQuantity;
    }
  }

  static void removeItem(Book book) {
    _cartItems.remove(book);
  }

  static void clearCart() {
    _cartItems.clear();
  }

  static double get totalPrice {
    double total = 0;
    _cartItems.forEach((book, quantity) {
      total += book.price * quantity;
    });
    return total;
  }
}