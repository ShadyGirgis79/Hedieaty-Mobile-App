
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedieaty/Model/Gift_Model.dart';
import 'package:hedieaty/Model/User_Model.dart' as LocalUser;

class GiftController{
  final Gift giftModel= Gift(name: "", category: "", price: 0, status: "");
  final LocalUser.User userModel = LocalUser.User(name: '', email: '', password: '', phoneNumber: '');
  final String currentUserID = FirebaseAuth.instance.currentUser!.uid;

  Future<List<Gift>?> giftsList(int eventId) async {
    try{
      return await giftModel.getEventGifts(eventId);
    }
    catch (e) {
      print("Error fetching user from local DB: $e");
      return null;
    }
  }

  Future<String> DeleteGift(String name , int id) async{
    await giftModel.deleteGift(name, id);
    return "$name gift has been deleted";
  }

  Future<String> UpdateGift(String name, String category , String description,
      String status , double price , String imageURL , int giftId) async{
    try {
      await giftModel.updateGift(name, category, status, imageURL, description, price , giftId);

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
      await giftModel.unpledgeGift(giftId);
      return "${name} is Available";
    }
    else{
      await giftModel.pledgeGift(giftId, userId);
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

    final LocalUser.User? user = await LocalUser.User.fetchUserByID(userId);
    return user!.name;
  }

}