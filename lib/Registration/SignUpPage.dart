import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/Home/HomePage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import '../Controller/ShowMessage.dart';
import '../Controller/SignUpController.dart';
import '../Controller/Validation.dart';
import 'dart:io';

import '../Database/Authentication.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController preferenceController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  XFile? imageFile;
  final ImagePicker picker = ImagePicker();

  final SignUpController signUpController = SignUpController();

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          imageFile = pickedFile;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }


  void SignUp() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final preference = preferenceController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final profilePath = imageFile != null ? imageFile!.path : "";

    String? errorMessage = await signUpController.signUp(
      name: name,
      email: email,
      phone: phone,
      preference: preference,
      password: password,
      confirmPassword: confirmPassword,
      profilePath: profilePath,
    );

    if (errorMessage != null) {
      showMessage(context, errorMessage);
      return;
    }

    try {
      User? firebaseUser = await AuthService().signUp(email, password);

      if (firebaseUser != null) {
        String userId = firebaseUser.uid;

        DatabaseReference userRef = FirebaseDatabase.instance.ref().child('users').child(userId);
        await userRef.set({
          'name': name,
          'email': email,
          'phone': phone,
          'preference': preference,
          'profilePath': profilePath,
        });

        await signUpController.listenForUserInsertion();

        showMessage(context, "'$name' registered successfully!");

        // Delayed navigation to ensure context is stable
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
      }
    } catch (e) {
      debugPrint("Sign-up error: ${e.toString()}");
      showMessage(context, "Error during registration: ${e.toString()}");
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.purple.withOpacity(.5),
                    width: 5.0,
                  ),
                ),
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: imageFile != null
                      ? FileImage(File(imageFile!.path))
                      : AssetImage("Assets/MyPhoto.png") as ImageProvider,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  pickImage();
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text("Change Profile Image"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purpleAccent[700],
                ),
              ),
              const SizedBox(height: 20),

              //Text field for Name
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),

              const SizedBox(height: 20),

              //Text field for Email
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.email),
                  errorText: emailController.text.isNotEmpty &&
                      !isValidEmail(emailController.text)
                      ? 'Enter a valid email'
                      : null,
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),

              const SizedBox(height: 20),

              //Text field for Preference
              TextField(
                controller: preferenceController,
                decoration: const InputDecoration(
                  labelText: "Preference",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.card_giftcard),
                ),
              ),

              const SizedBox(height: 15),

              //Text field for Phone
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                  errorText: phoneController.text.isNotEmpty &&
                      !validatePhoneNumber(phoneController.text)
                      ? "Invalid Egyptian phone number"
                      : null,
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  setState(() {});
                },
              ),

              const SizedBox(height: 15),

              //Text field for Password
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),

              const SizedBox(height: 15),

              //Text field for Confirm Password
              TextField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: SignUp,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50, vertical: 15),
                  backgroundColor: Colors.purpleAccent[700],
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    backgroundColor: Colors.purpleAccent[700],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
