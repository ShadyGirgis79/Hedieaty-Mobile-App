
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hedieaty/Model/User_Model.dart' as LocalUser;

class AddFriendController {
  late final LocalUser.User userModel;
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  final String currentUserID = FirebaseAuth.instance.currentUser!.uid;

  Future<String> addFriendLocalDB(String name, String phone) async {
    try {
      // Fetch friend by name and phone
      LocalUser.User? friend = await LocalUser.User.fetchUserByNameAndPhone(name, phone);
      userModel = (await LocalUser.User.fetchUserByID(currentUserID.hashCode))!;

      if (friend == null) {
        return "User with this phone number does not exist!";
      }

      // Check if already friends
      bool alreadyFriends = await userModel.checkIfFriends(userModel.id!, friend.id!);
      if (alreadyFriends) {
        return "You are already friends with this user!";
      }

      // Add friend relationship in both directions
      await userModel.addFriend(userModel.id!, friend.id!);
      await userModel.addFriend(friend.id!, userModel.id!);

      return "Friend added successfully!";
    }
    catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  Future<String> addFriendFirebase(String name, String phone) async {
    try {
      // Fetch user by name and phone
      DatabaseReference usersRef = databaseRef.child("users");

      // Query to find user with the matching phone
      DataSnapshot snapshot = await usersRef.orderByChild("phone").equalTo(phone).get();

      if (!snapshot.exists) {
        return "User with this phone number does not exist!";
      }

      // Find the friend's user ID based on the snapshot
      String? friendID;
      snapshot.children.forEach((childSnapshot) {
        if (childSnapshot.child("name").value == name) {
          friendID = childSnapshot.key; // friend's userID
        }
      });

      if (friendID == null) {
        return "No user found with this name and phone!";
      }

      // Get references to both users' friends lists
      DatabaseReference userFriendsRef = databaseRef.child("users/$currentUserID/friends");
      DatabaseReference friendFriendsRef = databaseRef.child("users/$friendID/friends");

      // Check if already friends
      DataSnapshot userSnapshot = await userFriendsRef.child(friendID!).get();
      if (userSnapshot.exists) {
        return "You are already friends with this user!";
      }

      // Add the friendship (both directions)
      await userFriendsRef.child(friendID!).set(true);
      await friendFriendsRef.child(currentUserID).set(true);

      return "Friend added successfully!";
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

}
