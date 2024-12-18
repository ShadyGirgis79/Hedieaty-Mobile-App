
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hedieaty/Model/Event_Model.dart';
import 'package:hedieaty/Model/Gift_Model.dart';
import 'package:hedieaty/Model/User_Model.dart' as LocalUser;

class GiftController{
  final Gift giftModel= Gift(name: "", category: "", price: 0, status: "");
  final LocalUser.User userModel = LocalUser.User(name: '', email: '', password: '', phoneNumber: '');
  final Event eventModel = Event(name: "", category: "", date: "");
  final String currentUserID = FirebaseAuth.instance.currentUser!.uid;
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  Future<List<Gift>?> giftsList(int eventId) async {
    try{
      return await giftModel.getUserEventGifts(eventId);
    }
    catch (e) {
      print("Error fetching user from local DB: $e");
      return null;
    }
  }

  Future<List<Gift>?> friendGiftsList(int eventId) async {
    try{
      return await giftModel.getFriendEventGifts(eventId);
    }
    catch (e) {
      print("Error fetching user from local DB: $e");
      return null;
    }
  }

  Future<String> DeleteGift(String name , int id) async{
    // Delete from Local Database
    await giftModel.deleteGift(name, id);

    // Delete from Firebase
    await databaseRef.child('gifts').child(id.toString()).remove();

    return "$name gift has been deleted";
  }

  Future<String> UpdateGift(String name, String category , String description,
      String status , double price , String imageURL , int giftId) async{
    try {
      // Update in Local Database
      await giftModel.updateGift(name, category, status, imageURL, description, price , giftId);

      // Update in Firebase
      await databaseRef.child('gifts').child(giftId.toString()).update({
        'name': name,
        'category': category,
        'description': description,
        'status': status,
        'price': price,
        'image': imageURL,
      });

      return "${name} event is updated successfully!";
    }
    catch (e) {
      // Handle any errors
      return "Failed to update event: $e";
    }
  }

  Future<bool> isPledgedChecker(int giftId) async{
    return await giftModel.isPledgedCheck(giftId);
  }

  Future<String> toggleIsPledged(int giftId , int userId , String name) async{
    bool result = await giftModel.isPledgedCheck(giftId);

    if(result == true){
      // Unpledge gift in Local Database
      await giftModel.unpledgeGift(giftId);

      // Update Firebase to mark as Available
      await databaseRef.child('gifts').child(giftId.toString()).update({
        'PledgedId': 0,
        'status': 'Available',
      });
      return "${name} is Available";
    }
    else{
      // Pledge gift in Local Database
      await giftModel.pledgeGift(giftId, userId);

      // Update Firebase to mark as pledged
      await databaseRef.child('gifts').child(giftId.toString()).update({
        'PledgedId': userId,
        'status': 'Pledged',
      });

      return "${name} is Pledged";
    }
  }

  Future<int> getPledgingUserID(int giftId) async {
    return await giftModel.getPledgedUserID(giftId);
  }

  Future<bool> checkPledgedUser(int giftId, int userId) async{
    int result = await giftModel.getPledgedUserID(giftId);

    if(result == userId){
      return true;
    }
    else{
      return false;
    }
  }

  Future<String?> getPledgedUserName(int giftId) async{
    final int userId = await giftModel.getPledgedUserID(giftId);

    final LocalUser.User? user = await userModel.fetchUserByID(userId);
    return user!.name;
  }

  Future<String?> getGiftEventName(int giftId) async{
    final int eventId = await giftModel.getGiftEventID(giftId);

    final Event? event = await eventModel.fetchEventByID(eventId);
    return event!.name;
  }

  Future<List<Gift>?> getUserPledgedGift(int userId) async {
    try{
      return await giftModel.getUserPledgedGifts(userId);
    }
    catch (e) {
      print("Error fetching user from local DB: $e");
      return null;
    }
  }

  Future<void> MakeGiftPublic(int id) async{
    try {
      //Update in Local Database
      await giftModel.makeGiftPublic(id);

      // Update event in Firebase
      await databaseRef.child('gifts').child(id.toString()).update({
        'publish': 1,
      });
    }
    catch (e) {
      // Handle any errors
      print("Failed to update event: $e");
    }
  }


}