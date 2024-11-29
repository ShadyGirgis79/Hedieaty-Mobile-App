import 'package:flutter/material.dart';
import 'package:hedieaty/Database/Database.dart';
import 'package:hedieaty/Home/HomePage.dart';
import 'package:hedieaty/Registration/SignUpPage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void SignIn() async{
    final name = nameController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || password.isEmpty) {
      showMessage("Please fill out all fields");
      return;
    }

    final db = HedieatyDatabase();
    // Query to check if the user exists with the provided name and password
    String sql = '''
      SELECT * FROM 'Users'
      WHERE Name = "$name" AND Password = "$password"
    ''';

    List<Map<String, dynamic>> result = await db.readData(sql);

    //To check for database tables
    List<Map> check = await db.readData("SELECT * FROM 'Users' ");
    print("$check");

    if (result.isNotEmpty) {
      // User found, mark them as active
      int userId = result[0]['ID'];

      // Set IsActive to 1 for the logged-in user
      await db.updateData("UPDATE 'Users' SET 'IsActive' = 1 WHERE ID = $userId");

      // Set IsActive to 0 for all other users
      await db.updateData("UPDATE 'Users' SET 'IsActive' = 0 WHERE ID != $userId");

      // User found
      showMessage("Logged in successfully!");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
            (Route<dynamic> route) => false, // Remove all previous routes
      );
    }
    else {
      // User not found or password incorrect
      showMessage("Invalid username or password");
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to free resources
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sign In",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.purpleAccent,
      ),
      body: SafeArea(
        child: SingleChildScrollView( // Makes the layout scrollable
          padding: const EdgeInsets.symmetric(horizontal: 20), // Add some padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),

              // App Title
              const Center(
                child: Text(
                  "Hedieaty",
                  style: TextStyle(
                    fontSize: 60,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.purpleAccent,
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
                ),
              ),

              const SizedBox(height: 20),

              // Name TextField
              TextField(
                controller: nameController, // Use controller
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(), // Optional: adds border
                ),
              ),

              const SizedBox(height: 20),

              // Password TextField
              TextField(
                controller: passwordController, // Use controller
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
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
                      onPressed: SignIn,
                      child: const Text("Sign In",
                        style: TextStyle(
                          fontSize: 18,
                        ),),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.purpleAccent,
                      ),
                    ),
                    const SizedBox(width: 50),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpPage(),
                          ),
                        );
                      },
                      child: const Text("Sign Up",
                        style: TextStyle(
                          fontSize: 18,
                        ),),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.purpleAccent,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
