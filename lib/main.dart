import 'package:flutter/material.dart';
import 'package:finalproject/Auth/register.dart';
import 'package:finalproject/Auth/login.dart';
import 'package:finalproject/MainScreen/home-page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {

    Future.delayed(Duration(seconds: 4)).then((value) =>
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => Register(),
          ),
        ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity ,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("images/splash.jpg"),
              fit: BoxFit.cover)
        ),
        child: Center(
          child: Text("Book App" ,style: TextStyle(
            fontSize: 42 , color: Colors.white , fontWeight: FontWeight.bold
          ),),
        ),
      ),

    );
  }
}
