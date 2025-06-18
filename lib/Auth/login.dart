import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finalproject/MainScreen/home-page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('saved_email');
    String? savedPassword = prefs.getString('saved_password');
    if (savedEmail != null && savedPassword != null) {
      setState(() {
        _emailController.text = savedEmail;
        _passwordController.text = savedPassword;
        rememberMe = true;
      });
    }
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve stored credentials
    String? storedEmail = prefs.getString('email')?.trim();
    String? storedPassword = prefs.getString('password');
    String? storedName = prefs.getString('firstName');

    print('Entered email: $email');
    print('Stored email: $storedEmail');
    print('Entered password: $password');
    print('Stored password: $storedPassword');

    // Check if user is registered
    if (storedEmail == null || storedPassword == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No registered user found. Please register first.')),
      );
      return;
    }

    // Validate credentials
    if (storedEmail == email && storedPassword == password) {
      if (rememberMe) {
        prefs.setString('saved_email', email);
        prefs.setString('saved_password', password);
      } else {
        prefs.remove('saved_email');
        prefs.remove('saved_password');
      }

      await prefs.setBool('loggedIn', true);
      await prefs.setString('username', storedName ?? '');

      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
           Positioned.fill(
              child: Opacity(
                 opacity: 0.2,
                child: Image.asset("images/register.png", fit: BoxFit.cover,),),
              ),
        Padding(
          padding: const EdgeInsets.only(top: 150 , right: 24 , left: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text("Login", style: TextStyle(
                    fontSize: 32, fontWeight: FontWeight.bold,
                    color: Color(0xFF4B331D)),
                ),
                SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: Colors.brown),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock, color: Colors.brown),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      activeColor: Colors.brown,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value!;
                        });
                      },
                    ),
                    Text("Remember Me", style: TextStyle(fontSize: 17, color: Color(0xFF4B331D))),
                  ],
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _login();
                    }
                  },
                  child: Text('Login', style: TextStyle(fontSize: 20, color: Color(0xFF4B331D))),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),

                  ),
                ),
                ),
              ],
            ),
          ),
        ),
      ],
      ),
    );
  }
}
