
import 'package:firebase_database/firebase_database.dart';
import 'package:hedieaty/Database/Database.dart';
import 'package:hedieaty/Model/User_Model.dart';
import 'Validation.dart';

class SignUpController {
  final User userModel = User(name: '', email: '', password: '', phoneNumber: '');

  Future<String?>signUp({
    required String name,
    required String email,
    required String phone,
    required String preference,
    required String password,
    required String confirmPassword,
    required String profilePath,
  }) async {
    if (name.isEmpty || phone.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      return "Please fill out all fields";
    }

    if (password != confirmPassword) {
      return "Passwords do not match";
    }

    if (!validatePhoneNumber(phone)) {
      return "Please enter a valid Egyptian phone number";
    }

    if (!isValidEmail(email)) {
      return "Please enter a valid email";
    }

    int response = await userModel.insertUser(
      name: name,
      password: password,
      profileURL: profilePath,
      phoneNumber: phone,
      email: email,
      preferences: preference,
    );

    userModel.getAllUsers();

    return response > 0 ? null : "Failed to register user";
  }

  Future<void> listenForUserInsertion() async {
    final db = HedieatyDatabase();
    var users = await db.queryUsers();
    for (var user in users) {
      String userId = user['Id'];
      String name = user['Name'];
      String email = user['Email'];
      String phone = user['Phone'];
      String preference = user['Preferences'];
      String profilePath = user['ProfileURL'];

      // Sync this user data with Firebase
      DatabaseReference userRef = FirebaseDatabase.instance.ref().child('users').child(userId);
      await userRef.set({
        'Name': name,
        'Email': email,
        'Phone': phone,
        'Preferences': preference,
        'ProfileURL': profilePath,
      });
    }
  }
}
