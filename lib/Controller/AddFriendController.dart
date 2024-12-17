
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hedieaty/Model/Friends_Model.dart';
import 'package:hedieaty/Model/User_Model.dart' as LocalUser;

class AddFriendController {
  late final LocalUser.User userModel;
  final Friends friendTable = Friends(UserId: 0, FriendId: 0);
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  final String currentUserID = FirebaseAuth.instance.currentUser!.uid;

  Future<String> addFriendLocalDB(String name, String phone) async {
    try {
      // Fetch friend by name and phone
      LocalUser.User? friend = await LocalUser.User.fetchUserByNameAndPhone(name, phone);
      LocalUser.User? userModel = await LocalUser.User.fetchUserByID(currentUserID.hashCode);

      if (friend == null) {
        return "User with this phone number does not exist!";
      }

      // Check if already friends
      bool alreadyFriends = await friendTable.checkIfFriends(userModel!.id!, friend.id!);
      if (alreadyFriends) {
        return "You are already friends with this user!";
      }

      // Add friend relationship in both directions
      await friendTable.addFriend(userModel.id!, friend.id!);
      await friendTable.addFriend(friend.id!, userModel.id!);

      await addFriendsFirebase();

      return "Friend added successfully!";
    }
    catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  Future<void> addFriendsFirebase() async{

    List<Map> friends = await friendTable.getAllFriends();

    for (var friend in friends){
      int friendshipId = friend['ID'];
      int userId = friend['UserID'];
      int friendId = friend['FriendID'];

      DatabaseReference friendsRef = databaseRef.child('friends').child(friendshipId.toString());
      await friendsRef.set({
        'UserId': userId,
        'FriendId': friendId,
      });

    }



  }

}

