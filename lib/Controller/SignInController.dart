
import 'package:hedieaty/Model/User_Model.dart';
import 'Validation.dart';

class SignInController{
  final User userModel = User(name: '', email: '', password: '', phoneNumber: '');

  Future<String?> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return "Please fill out all fields";
    }

    if (!isValidEmail(email)) {
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


}