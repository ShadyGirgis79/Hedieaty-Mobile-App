import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/Database/Database.dart';

import '../Controller/ShowMessage.dart';
import '../Controller/SignInController.dart';
import '../Controller/Validation.dart';
import '../Database/Authentication.dart';
import '../Home/HomePage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final SignInController signInController = SignInController();

  void SignIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Call authentication service
    final user = await AuthService().signIn(email, password);
    if (user != null) {
      showMessage(context, "Logged in successfully!");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }
    else {
      showMessage(context, "Failed to log in. Please check your credentials.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView( // Makes the layout scrollable
          padding: const EdgeInsets.symmetric(horizontal: 20), // Add some padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),


              // App Title
              Center(
                child: Text(
                  "Hedieaty",
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.purpleAccent[700],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Image
              Center(
                child: Container(
                  child: Image.asset("Assets/Gift.jpg"),
                  height: 300,
                  width: 300,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.email),
                  // Show error only when text is not empty and invalid
                  errorText: emailController.text.isNotEmpty && !isValidEmail(emailController.text)
                      ? 'Enter a valid email'
                      : null,
                ),
                onChanged: (value) {
                  setState(() {}); // Update UI on every change
                },
              ),

              const SizedBox(height: 20),

              // Password TextField
              TextField(
                controller: passwordController, // Use controller
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock)
                ),
                obscureText: true, // Obscures the text for password input
              ),

              const SizedBox(height: 30),

              // Buttons Row
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: const Text("Sign In",
                        style: TextStyle(
                          fontSize: 18,
                        ),),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.purpleAccent[700],
                      ),
                      onPressed: (){
                        SignIn();
                      },

                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed("/SignUp") ;
                },
                child: Center(
                  child: Text.rich(TextSpan(children: [
                    const TextSpan(
                      text: "Don't Have An Account ? ",
                    ),
                    TextSpan(
                        text: "Sign up",
                        style: TextStyle(
                            color: Colors.purpleAccent[700],
                            fontWeight: FontWeight.bold)),
                    ])
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
