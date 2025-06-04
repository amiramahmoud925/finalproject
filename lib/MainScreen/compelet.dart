import 'package:flutter/material.dart';
import 'package:finalproject/MainScreen/home-page.dart';

class Compelet extends StatefulWidget {
  const Compelet({super.key});

  @override
  State<Compelet> createState() => _CompeletState();
}

class _CompeletState extends State<Compelet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE8D2),
      appBar: AppBar(backgroundColor: const Color(0xFFFCE8D2),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 200,width: 200,
              decoration: BoxDecoration(
                color: Color(0xFFFCE8D2),
                image: DecorationImage(image: AssetImage("images/done.png"),fit: BoxFit.fill,
                )
              ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30 , vertical: 20),
            child: Text("Your Order Is Compeleted" , style: TextStyle(
              fontSize: 25,fontWeight: FontWeight.bold , color: Color(0xFF4B331D),
            ),),
          ),
          ElevatedButton(onPressed:(){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
          },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[800],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text('Back Home'))
        ],
      ),
    );
  }
}
