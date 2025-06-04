import 'package:flutter/material.dart';
import 'package:finalproject/MainScreen/data.dart';
import 'package:finalproject/MainScreen/compelet.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    final orders = OrderManager.orders;

    return Scaffold(
      backgroundColor: const Color(0xFFFCE8D2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCE8D2),
        title: const Text("Orders"),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.brown[800]),
        titleTextStyle: TextStyle(
          color: Colors.brown[800],
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: orders.isEmpty
          ? const Center(
        child: Text("No orders placed yet.", style: TextStyle(fontSize: 18)),
      )
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Column(
            children: [
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Date: ${order.date.toLocal().toString().split(' ')[0]}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Divider(),
                      ...order.items.expand((item) => item.entries).map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text('${entry.value} × ${entry.key.title}'),
                        );
                      }).toList(),
                      const SizedBox(height: 10),
                      Text(
                        'Total: \$${order.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top:15, bottom: 12),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Compelet()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[800],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Compelet"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
class Order {
  final List<Map<Book, int>> items;
  final DateTime date;

  Order({required this.items, required this.date});

  double get totalPrice {
    double total = 0;
    for (var item in items) {
      item.forEach((book, quantity) {
        total += book.price * quantity;
      });
    }
    return total;
  }
}

class OrderManager {
  static final List<Order> _orders = [];

  static List<Order> get orders => _orders;

  static void placeOrder(List<Map<Book, int>> items) {
    _orders.add(Order(items: items, date: DateTime.now()));
  }
}