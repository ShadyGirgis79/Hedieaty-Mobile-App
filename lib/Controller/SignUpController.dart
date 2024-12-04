
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

    return response > 0 ? null : "Failed to register user";
  }
}