import 'package:flutter/material.dart';
import 'package:finalproject/Auth/login.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE8D2),
      appBar: AppBar(
          backgroundColor: const Color(0xFFFCE8D2),
          title: Text("Profile")
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50 , horizontal: 75),
        child: Column(
          children: [
            CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage('images/splash.jpg'),
            ),
            SizedBox(height: 16),
            Text("Amira Mahmoud", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("amira456@gmail.com", style: TextStyle(fontSize: 16, color: Colors.grey)),
            Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
              },
              icon: Icon(Icons.logout , color: Colors.white ),
              label: Text("Logout" , style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
            ),
          ],
        ),
      ),
    );
  }
}
