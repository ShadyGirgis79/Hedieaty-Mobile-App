import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedieaty/Model/User_Model.dart' as LocalUser;

class ProfileController {
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

  /// Fetch user data from Firebase
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

  /// Update user data in both SQLite and Firebase
  Future<void> updateUserData({
    required String newName,
    required String newPhoneNumber,
    required String newPreference,
    String? newProfileURL,
  }) async {
    try {
      final int hashedID = currentUserID.hashCode;

      // Update in Firebase
      final DatabaseReference userRef = FirebaseDatabase.instance.ref("users/$currentUserID");
      await userRef.update({
        'name': newName,
        'phone': newPhoneNumber,
        'preference': newPreference,
        if (newProfileURL != null) 'profileURL': newProfileURL,
      });

      // Update in SQLite
      final LocalUser.User? user = await LocalUser.User.fetchUserByID(hashedID);
      if (user != null) {
        await user.updateUser(
          newName,
          newProfileURL ?? user.profileURL,
          newPhoneNumber,
          newPreference,
          user.email,
          user.password,
        );
        print("User data updated successfully in both SQLite and Firebase.");
      }
      else {
        print("User not found in SQLite for update.");
      }
    }
    catch (e) {
      print("Error updating user data: $e");
    }
  }
}
