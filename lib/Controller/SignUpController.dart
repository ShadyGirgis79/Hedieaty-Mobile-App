
import 'package:firebase_database/firebase_database.dart';
import 'package:hedieaty/Model/User_Model.dart';
import 'Functions/Validation.dart';

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

    if (!validateEmail(email)) {
      return "Please enter a valid email";
    }

    if (password.length < 6){
      return "Password must at least 6 characters";
    }

    // Check for duplicates
    bool isDuplicateName = await userModel.isDuplicatedUserName(name);
    bool isDuplicateEmail = await userModel.isDuplicatedUserEmail(email);
    bool isDuplicatePhone = await userModel.isDuplicatedUserPhone(phone);
    bool isDuplicatePassword = await userModel.isDuplicatedUserPassword(password);

    if (isDuplicateName) {
      return "A user with the same name already exists.";
    }
    if (isDuplicateEmail) {
      return "A user with the same email already exists.";
    }
    if (isDuplicatePhone) {
      return "A user with the same phone number already exists.";
    }
    if (isDuplicatePassword) {
      return "A user with the same password already exists.";
    }

    int response = await userModel.insertUser(
      name: name,
      password: password,
      profileURL: profilePath,
      phoneNumber: phone,
      email: email,
      preferences: preference,
    );

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

  Future<void> updateID(String email, String password, int newId) async {
    // Fetch the user by email and password
    User? user = await userModel.fetchUserByEmailAndPassword(email, password);

    if (user != null) {
      // Update the user's ID in the local database
      int updateUser = await user.updateUserID(email, password, newId);

      if (updateUser > 0) {
        print("User ID updated successfully.");
      }
      else {
        print("Failed to update user ID.");
      }
    }
    else {
      print("User not found. Cannot update ID.");
    }
  }
}
