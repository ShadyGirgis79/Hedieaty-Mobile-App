
import 'package:hedieaty/Model/User_Model.dart';
import 'Functions/Validation.dart';

class SignInController{
  final User userModel = User(name: '', email: '', password: '', phoneNumber: '');

  Future<String?> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return "Please fill out all fields";
    }

    if (!validateEmail(email)) {
      return "Enter a valid email address";
    }

    try {
      final result = await userModel.getUserByEmailAndPassword(email, password);
      if (result.isNotEmpty) {
        return null; // Success
      }
      else {
        return "Invalid email or password";
      }
    }
    catch (e) {
      print("Database Error: $e");
      return "Error: Unable to log in";
    }
  }


  Future<void> updateID(String email, String password, int newId) async {
    // Fetch the user by email and password
    User? user = await User.fetchUserByEmailAndPassword(email, password);

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