import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedieaty/Model/User_Model.dart' as LocalUser;

class HomeController {
  final LocalUser.User localUser = LocalUser.User(name: '', email: '', password: '', phoneNumber: ''); // Instance of the local User model
  final String currentUserID = FirebaseAuth.instance.currentUser!.uid;

  /// Fetch user data from SQLite by ID
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

  // Fetch user data from Firebase
  Future<Map<dynamic, dynamic>?> fetchUserFromFirebase() async {
    try {
      final DatabaseReference userRef = FirebaseDatabase.instance.ref("users/$currentUserID");
      final DataSnapshot snapshot = await userRef.get();
      if (snapshot.exists) {
        return snapshot.value as Map<dynamic, dynamic>;
      }
      else {
        print("No user data found in Firebase for $currentUserID");
        return null;
      }
    } catch (e) {
      print("Error fetching user from Firebase: $e");
      return null;
    }
  }

}
