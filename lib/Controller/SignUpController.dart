
import 'package:firebase_database/firebase_database.dart';
import 'package:hedieaty/Model/User_Model.dart';
import 'Functions/Validation.dart';

class SignUpController {
  final User userModel = User(name: '', email: '', password: '', phoneNumber: '');

  Future<String?>signUp({
    required int id,
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

    if (!validateEmail(email)) {
      return "Please enter a valid email";
    }

    if (password.length < 6){
      return "Password must at least 6 characters";
    }


    int response = await userModel.insertUser(
      id:id,
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


  Future<void> listenForUserInsertion(int id) async {
    // Fetch all users from the local SQLite database
    List<Map> users = await userModel.getAllUsers();


    for (var user in users) {
      int userId = id;
      String name = user['Name'];
      String email = user['Email'];
      String phone = user['PhoneNumber'];
      String password = user['Password'];
      String preference = user['Preferences'] ?? '';
      String profileURL = user['ProfileURL'] ?? '';


      // Sync this user data with Firebase
      DatabaseReference userRef = FirebaseDatabase.instance.ref()
          .child('users').child(userId.toString());
      await userRef.set({
        'name': name,
        'email': email,
        'phone': phone,
        'password':password,
        'preference': preference,
        'profileURL': profileURL,
      });
    }
  }

}
