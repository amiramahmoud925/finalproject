import 'package:flutter/material.dart';
import 'package:finalproject/MainScreen/data.dart';
import 'package:finalproject/MainScreen/home-page.dart';
import 'package:finalproject/MainScreen/cart-page.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key, required this.book});

  final Book book;

  @override
  State<ProductDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<ProductDetailsPage> {
  int _count = 0;

  void increment() {
    setState(() {
      _count++;
    });
  }

  void decrement() {
    setState(() {
      if (_count > 0) {
        _count--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCE8D2),
      appBar: AppBar(
        backgroundColor: Color(0xFFFCE8D2),
          title: Text(widget.book.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 340,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                child: Image.asset(widget.book.image, fit: BoxFit.fill,),
              ),
            ),
            SizedBox(height: 16),
           Padding(
             padding: const EdgeInsets.all(15),
             child: Column(
               children: [
                 Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(
                       "Author : ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                     ),
                     Expanded(
                       child: Text(widget.book.author, style: TextStyle(fontSize: 15,
                           color: Colors.grey, fontWeight: FontWeight.bold),
                       ),
                     ),
                   ],
                 ),
                 SizedBox(height: 10),
                 Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text("Description : ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                     ),
                     Expanded(
                       child: Text(widget.book.description, style: TextStyle(fontSize: 15,
                           color: Colors.grey, fontWeight: FontWeight.bold),
                       ),
                     ),
                   ],
                 ),
                 SizedBox(height: 10),
                 Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text("Price : ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                     ),
                     Expanded(
                       child: Text("\$${widget.book.price.toStringAsFixed(2)}", style: TextStyle(fontSize: 15,
                           color: Colors.grey, fontWeight: FontWeight.bold),
                       ),
                     ),
                   ],
                 ),
                 SizedBox(height: 10,),
                 Row(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     ElevatedButton(
                       onPressed: _count > 0 ? decrement : null ,
                       style: ElevatedButton.styleFrom(
                         shape: CircleBorder(),
                         padding: EdgeInsets.all(15),
                         foregroundColor: Color(0xFF4B331D),
                       ), child: Icon(Icons.remove),
                     ),
        
                     SizedBox(width: 10,),
                     Text('$_count' , style: TextStyle(color: Colors.black , fontSize: 25),),
                     SizedBox(width: 10,),
                     ElevatedButton(
                       onPressed: increment,
                       style: ElevatedButton.styleFrom(
                         shape: CircleBorder(),
                         padding: EdgeInsets.all(15),
                         foregroundColor: Color(0xFF4B331D),
                       ), child: Icon(Icons.add),
                     ),
                   ],
                 ),
                 SizedBox(height: 50),
                 ElevatedButton(
                   onPressed: () {
                     if (_count > 0) {
                       CartManager.addToCart(widget.book, _count);
                       ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(content: Text("Added $_count item(s) to cart")),
                       );
                     }
                     Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
                   },
                   child: Text('Add to Cart', style: TextStyle(fontSize: 20, color: Color(0xFF4B331D))),
                   style: ElevatedButton.styleFrom(
                     minimumSize: Size(double.infinity, 50),
                     backgroundColor: Colors.white,
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                     padding: EdgeInsets.symmetric(vertical: 14),
                   ),
                 ),
               ],
             ),
           )
          ],
        ),
      ),
    );
  }
}
