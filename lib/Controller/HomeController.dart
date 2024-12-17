
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedieaty/Model/User_Model.dart' as LocalUser;

class HomeController {
  final LocalUser.User userModel= LocalUser.User(name: '', email: '', password: '', phoneNumber: ''); // Instance of the local User model
  final String currentUserID = FirebaseAuth.instance.currentUser!.uid;

  // Fetch user data from SQLite by ID
  Future<LocalUser.User?> fetchUserFromLocalDB() async {
    try {
      final int hashedID = currentUserID.hashCode;
      return await LocalUser.User.fetchUserByID(hashedID);
    }
    catch (e) {
      print("Error fetching user from local DB: $e");
      return null;
    }
  }

  Future<List<LocalUser.User>?> friendsList(int userId) async{
    try{
      return await userModel.getFriends(userId);
    }
    catch (e) {
      print("Error fetching user from local DB: $e");
      return null;
    }

  }

}
