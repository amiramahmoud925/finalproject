import 'dart:convert';
import 'dart:io';
import 'package:finalproject/Auth/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();

  String? selectedGender;
  DateTime? selectedDate;
  File? _avatar;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _avatar = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _birthController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final nameParts = _nameController.text.trim().split(' ').where((part) => part.isNotEmpty).toList();
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : 'N/A';

    if (firstName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your full name.')),
      );
      return;
    }

    if (selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a gender.')),
      );
      return;
    }

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your birth date.')),
      );
      return;
    }

    final url = Uri.parse('https://ib.jamalmoallart.com/api/v2/register');

    final data = {
      "first_name": firstName,
      "last_name": lastName,
      "phone": _phoneController.text.trim(),
      "address": _addressController.text.trim(),
      "email": _emailController.text.trim(),
      "password": _passwordController.text,
      "gender": selectedGender,
      "birth_date": selectedDate!.toIso8601String(),
    };

    try {
      final response = await http.post( url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      final jsonResponse = jsonDecode(response.body);
      final success = jsonResponse['state'];
      final message = jsonResponse['message'] ?? 'Unknown response';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

      if (success) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', _emailController.text.trim());
        await prefs.setString('firstName', firstName);
        await prefs.setString('lastName', lastName);
        await prefs.setString('phone', _phoneController.text.trim());
        await prefs.setString('address', _addressController.text.trim());
        await prefs.setString('gender', selectedGender!);
        await prefs.setString('birthDate', selectedDate!.toIso8601String());
        await prefs.setString('password', _passwordController.text);
        if (_avatar != null) {
          await prefs.setString('avatarPath', _avatar!.path);
        }

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Unable to connect.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Positioned.fill(
          child: Opacity(
            opacity: 0.2,
            child: Image.asset("images/register.png", fit: BoxFit.cover),
          ),
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: Form(
            key: _formKey,
            child: Column(children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _avatar != null
                          ? FileImage(_avatar!)
                          : const AssetImage("images/me.jpeg") as ImageProvider,
                    ),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.brown,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                        onPressed: _pickImage,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text("Register", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF4B331D))),
              const SizedBox(height: 30),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Full Name",
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (val) {
                  final nameParts = val?.trim().split(' ').where((part) => part.isNotEmpty).toList() ?? [];
                  if (nameParts.length < 2) return 'Please enter both first and last name';
                  return null;
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Phone Number",
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _confirmpasswordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Confirm Password",
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (val) {
                  if (val != _passwordController.text) return 'Passwords do not match';
                  return null;
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Address",
                  prefixIcon: Icon(Icons.place),
                ),
                maxLines: 2,
              ),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _birthController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Birth of Date",
                      prefixIcon: Icon(Icons.cake),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Row(
                children: [
                  const Text("Gender:", style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  _genderOption('Male'),
                  _genderOption('Female'),
                ],
              ),
              const SizedBox(height: 25),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Already have an account?', style: TextStyle(color: Colors.brown)),
                    SizedBox(width: 5),
                    Text('Login', style: TextStyle(fontSize: 20, color: Colors.black54)),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 100),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Register", style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _genderOption(String gender) {
    return Row(
      children: [
        Radio<String>(
          value: gender,
          groupValue: selectedGender,
          onChanged: (value) {
            setState(() {
              selectedGender = value;
            });
          },
        ),
        Text(gender),
      ],
    );
  }
}
