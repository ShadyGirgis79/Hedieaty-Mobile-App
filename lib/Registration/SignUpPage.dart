import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/Controller/Internet.dart';
import 'package:hedieaty/Home/HomePage.dart';
import 'package:hedieaty/Model/Database/SyncFirebaseAndLocalDB.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import '../Controller/Functions/ShowMessage.dart';
import '../Controller/SignUpController.dart';
import '../Controller/Functions/Validation.dart';
import '../Model/Database/Authentication.dart';


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
  File? imageFile;
  final SignUpController signUpController = SignUpController();
  final Internet internet = Internet();

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }


  void SignUp() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final preference = preferenceController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final profilePath = imageFile?.path ?? "";



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

        await signUpController.listenForUserInsertion(firebaseUser.uid.hashCode);
        await signUpController.updateID(email, password, firebaseUser.uid.hashCode);

        showMessage(context, "$name registered successfully!");

        SyncFirebaseAndLocalDB syncController = SyncFirebaseAndLocalDB();
        await syncController.syncFirebaseToLocalDB();

        // Delayed navigation to ensure context is stable
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MyHomePage()),
              (Route<dynamic> route) => false,
        );
      }
    }
    catch (e) {
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
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.purple.withOpacity(.5),
                    width: 5.0,
                  ),
                ),
                child: ClipOval(
                  child: imageFile != null
                    ? Image.file(imageFile!, height: 300, width: 300, fit: BoxFit.cover)
                    : const Icon(Icons.image,size: 300, color: Colors.grey ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: pickImage,
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
                      !validateEmail(emailController.text)
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
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  errorText: passwordController.text.isNotEmpty &&
                        passwordController.text.length < 6
                      ? 'Password must be at least 6 characters'
                      : null
                ),
                obscureText: true,
                onChanged: (value) {
                  setState(() {});
                },
              ),

              const SizedBox(height: 15),

              //Text field for Confirm Password
              TextFormField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                    errorText: confirmPasswordController.text.isNotEmpty &&
                        confirmPasswordController.text.length < 6
                        ? 'Password must be at least 6 characters'
                        : null
                ),
                obscureText: true,
                onChanged: (value) {
                  setState(() {});
                },
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async{
                  bool isConnected = await internet.checkInternetConnection();
                  if (!isConnected) {
                    internet.showLoadingIndicator(context); // Show loading until connected
                    await internet.waitForInternetConnection(); // Wait for internet
                    Navigator.pop(context); // Close the loading dialog
                  }

                  SignUp();
                },
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
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
