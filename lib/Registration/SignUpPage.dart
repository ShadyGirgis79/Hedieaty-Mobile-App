
import 'package:flutter/material.dart';
import 'package:hedieaty/Database/Database.dart';
import 'package:hedieaty/Registration/SignInPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  XFile? imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          imageFile = pickedFile;
        });
      }
    } catch (e) {
      // Handle errors, such as permission denial
      debugPrint('Error picking image: $e');
    }
  }

  void SignUp() async{
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final profilePath = imageFile != null ? imageFile!.path : "";

    if (name.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showMessage("Please fill out all fields");
      return;
    }

    if (password != confirmPassword) {
      showMessage("Passwords do not match");
      return;
    }

    if (isValidPhone == false) {
      showMessage("Please enter a valid Egyptian phone number");
      return;
    }

    final db = HedieatyDatabase();
    String sql = '''
      INSERT INTO Users ('Name' , 'Password' , 'ProfileURL' , 'PhoneNumber')
      VALUES ("$name" , "$password" , "$profilePath" , "$phone")
    ''';
    int response = await db.insertData(sql);

    //To check for database tables
    List<Map> check = await db.readData("SELECT * FROM 'Users' ");
    print("$check");


    if(response > 0){
      showMessage("User registered successfully!");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
            (Route<dynamic> route) => false, // Remove all previous routes
      );
    }
    else {
      showMessage("Failed to register user");
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool isValidPhone = true;

  void validatePhoneNumber(String value) {
    final RegExp egyptianPhoneRegex = RegExp(r'^(01[0-2,5]{1}[0-9]{8})$');
    setState(() {
      isValidPhone = egyptianPhoneRegex.hasMatch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Log In",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.purpleAccent,
      ),
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
                      : AssetImage("Assets/MyPhoto.png") as ImageProvider, // Replace with your image path
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
                  backgroundColor: Colors.purpleAccent,
                ),
              ),

              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              //Check for egyptian phone number validation
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(),
                  errorText: isValidPhone ? null : "Invalid Egyptian phone number",
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allows only digits
                ],
                onChanged: (value) {
                  validatePhoneNumber(value); // Validate on every change
                },
              ),

              const SizedBox(height: 15),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),

              const SizedBox(height: 15),
              TextField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: SignUp,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: Colors.purpleAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  "Log In",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    backgroundColor: Colors.purpleAccent,
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
