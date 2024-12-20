
import 'package:flutter/material.dart';
import 'package:hedieaty/Controller/Services/Internet.dart';
import 'package:hedieaty/Model/Database/SyncFirebaseAndLocalDB.dart';
import '../Controller/Functions/ShowMessage.dart';
import '../Controller/SignInController.dart';
import '../Controller/Functions/Validation.dart';
import '../Home/HomePage.dart';
import '../Controller/Services/Authentication.dart';
import '../Model/User_Model.dart';


class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Internet internet = Internet();
  final SignInController signInController = SignInController();
  final User userModel = User(name: "", email: "", password: "", phoneNumber: "");

  void SignIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Call authentication service
    final user = await AuthService().signIn(email, password);
    if (user != null) {
      final currentUser = await userModel.fetchUserByEmailAndPassword(email, password);

      if(currentUser != null){
        await signInController.updateID(email, password, user.uid.hashCode);
        showMessage(context, "Logged in successfully!");

        SyncFirebaseAndLocalDB syncController = SyncFirebaseAndLocalDB();
        await syncController.syncFirebaseToLocalDB();

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      }
     else{
        showMessage(context, "User is not found");
      }
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
              // Image
              Center(
                child: Container(
                  child: Image.asset("Assets/2PURPLE.png"),
                  height: 500,
                  width: 500,
                ),
              ),

              TextField(
                key: Key('emailTextField'),
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.email),
                  // Show error only when text is not empty and invalid
                  errorText: emailController.text.isNotEmpty
                      && !validateEmail(emailController.text)
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
                key: Key('passwordTextField'),
                controller: passwordController, // Use controller
                decoration: InputDecoration(
                  labelText: "Password",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  errorText: passwordController.text.isNotEmpty &&
                      passwordController.text.length < 6
                      ? 'Password must be at least 6 characters'
                      : null
                ),
                obscureText: true, // Obscures the text for password input
                onChanged: (value) {
                  setState(() {});
                },
              ),

              const SizedBox(height: 30),

              // Buttons Row
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      key: Key('signInButton'),
                      child: const Text("Sign In",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.purpleAccent[700],
                      ),
                      onPressed: () async {
                        bool isConnected = await internet.checkInternetConnection();
                        if (!isConnected) {
                          internet.showLoadingIndicator(context); // Show loading until connected
                          await internet.waitForInternetConnection(); // Wait for internet
                          Navigator.pop(context); // Close the loading dialog
                        }
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
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
