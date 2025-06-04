import 'package:flutter/material.dart';
import 'package:finalproject/MainScreen/data.dart';
import 'package:finalproject/MainScreen/product-detail.dart';


class ProductPage extends StatelessWidget {
  final String category;
  final List<Book> books;
  const ProductPage({super.key , required this.category , required this.books});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Color(0xFFD0B296),
      ),
      backgroundColor: Color(0xFFD0B296),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: books.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          final book = books[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => ProductDetailsPage(book: book),
              ));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Image.asset(book.image, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.black54),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(book.title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), maxLines: 1),
                          Text(book.author, style: TextStyle(color: Colors.white70), maxLines: 1),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

