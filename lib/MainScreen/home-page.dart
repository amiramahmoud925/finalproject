import 'package:finalproject/Auth/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finalproject/MainScreen/data.dart';
import 'package:finalproject/MainScreen/product-detail.dart';
import 'package:finalproject/MainScreen/profile.dart';
import 'package:finalproject/MainScreen/product-page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Book> books = bookList;
  PageController _pageController = PageController();
  int currentpage = 0;
  String username = '';

  final List<String> categories = [
  'Art', 'Finance', 'Children', 'Self-Help', 'Fiction', 'Environment',
  'Classic', 'Fantasy', 'Technology', 'History', 'Spirituality',
  'Motivation', 'Productivity', 'Science Fiction', 'Adventure', 'Cyberpunk'
  ];


  void pagechange(index) {
    setState(() {
      currentpage = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }

  void toggleFavorite(Book book) {
    setState(() {
      book.isFavorite = !book.isFavorite;
    });
  }

  void _searchTasks() {
    showSearch(context: context, delegate: TaskSearchDelegate(books));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCE8D2),
      appBar: AppBar(
        backgroundColor: Color(0xFFFCE8D2),
        title: Text('Welcome $username', style: TextStyle(color: Color(0xFF4B331D))),
        actions: [
          IconButton(
            onPressed:_searchTasks,
            icon: Icon(Icons.search, size: 25, color: Color(0xFF4B331D)),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Profile') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
              } else if (value == 'Logout') {
                if (value == 'Logout') {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Logout'),
                      content: Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: Text('Logout'),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> Login())
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }

              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'Profile', child: Text('Profile')),
              PopupMenuItem(value: 'Logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8),
              child: Text("Book App", style: TextStyle(fontSize: 25, color: Color(0xFF4B331D))),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: pagechange,
                  children: [
                    for (var i = 1; i <= 5; i++)
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                        clipBehavior: Clip.hardEdge,
                        child: Image.asset("images/0$i.png", fit: BoxFit.fill),
                      ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Container(
                  margin: EdgeInsets.all(4),
                  width: currentpage == index ? 20 : 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: currentpage == index ? Color(0xFF4B331D) : Colors.grey,
                    borderRadius: BorderRadius.circular(6),
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text("Books", style: TextStyle(fontSize: 21,
                  fontWeight: FontWeight.bold, color: Color(0xFF4B331D)),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 430,
              child: GridView.builder(
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => ProductDetailsPage(book: book),
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            Image.asset(book.image, fit: BoxFit.cover,
                              width: double.infinity, height: double.infinity,
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(8), color: Colors.black54,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(book.title, style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white, fontSize: 14),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(book.author, style: TextStyle(color: Colors.white70, fontSize: 12),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        book.isFavorite ? Icons.favorite : Icons.favorite_border,
                                        color: book.isFavorite ? Colors.red : Colors.white,
                                        size: 20,
                                      ),
                                      onPressed: () => toggleFavorite(book),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20, left: 10),
              child: Text("Product Categories",
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Color(0xFF4B331D)),
              ),
            ),
            Container(
              height: 120,
              margin: EdgeInsets.only(top: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  String selectedCategory = categories[index];
                  Book? firstBook = books.firstWhere((book) => book.category == selectedCategory, orElse: () => books[index % books.length]);

                  return GestureDetector(
                    onTap: () {
                      List<Book> filteredBooks = books.where((book) => book.category == selectedCategory).toList();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductPage(category: selectedCategory, books: filteredBooks),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(8),
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(firstBook.image, fit: BoxFit.cover),
                          Container(
                            color: Colors.black26,
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(selectedCategory,
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                        ],
                      ),
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

class TaskSearchDelegate extends SearchDelegate {
  final List<Book> books;
  TaskSearchDelegate(this.books);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear, color: Color(0xFF4B331D)),
        onPressed: () {query = '';},
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Color(0xFF4B331D)),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = books
        .where((book) => book.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildSearchResults(results, context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = books
        .where((book) => book.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildSearchResults(suggestions, context);
  }

  Widget _buildSearchResults(List<Book> results, BuildContext context) {
    if (results.isEmpty) {
      return Center(child: Text('No books found', style: TextStyle(color: Color(0xFF4B331D))));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final book = results[index];
        return ListTile(
          leading: Image.asset(book.image, width: 50, height: 70, fit: BoxFit.cover),
          title: Text(book.title, style: TextStyle(color: Color(0xFF4B331D))),
          subtitle: Text(book.author),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => ProductDetailsPage(book: book),
            ));
          },
        );
      },
    );
  }
}

