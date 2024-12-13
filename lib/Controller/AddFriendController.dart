
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

  // Add a friend to the user's friends list in Firebase Realtime Database
  Future<String> addFriendFirebase(String name, String phone) async {
    try {
      // Reference to the users table
      DatabaseReference usersRef = databaseRef.child("users");

      // Query to find the friend by phone
      DataSnapshot snapshot = await usersRef.orderByChild("phone").equalTo(phone).get();

      if (!snapshot.exists) {
        return "User with this phone number does not exist!";
      }

      // Find the friend's user ID by name and phone
      String? friendID;
      for (var childSnapshot in snapshot.children) {
        if (childSnapshot.child("name").value == name) {
          friendID = childSnapshot.key; // Friend's user ID
          break;
        }
      }

      if (friendID == null) {
        return "No user found with this name and phone!";
      }

      // Reference to the current user's and friend's friends lists
      DatabaseReference currentUserFriendsRef = databaseRef.child("users/$currentUserID/friends");
      DatabaseReference friendFriendsRef = databaseRef.child("users/$friendID/friends");

      // Check if already friends
      DataSnapshot userSnapshot = await currentUserFriendsRef.child(friendID).get();
      if (userSnapshot.exists) {
        return "You are already friends with this user!";
      }

      // Add friendship in both directions
      await currentUserFriendsRef.child(friendID).set(true); // Add friend to current user's list
      await friendFriendsRef.child(currentUserID).set(true); // Add current user to friend's list

      return "Friend added successfully!";
    }
    catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  // Fetches the list of friends for the current user
  Future<List<String>> getFriends() async {
    try {
      DatabaseReference currentUserFriendsRef = databaseRef.child("users/$currentUserID/friends");
      DataSnapshot snapshot = await currentUserFriendsRef.get();

      if (!snapshot.exists) {
        return [];
      }

      List<String> friends = [];
      for (var childSnapshot in snapshot.children) {
        friends.add(childSnapshot.key!); // Add the friend's ID to the list
      }
      return friends;
    }
    catch (e) {
      throw Exception("Error fetching friends: ${e.toString()}");
    }
  }
}

