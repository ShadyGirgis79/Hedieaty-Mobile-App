
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedieaty/Model/Gift_Model.dart';

class GiftController{
  final Gift giftModel= Gift(name: "", category: "", price: 0, status: "");
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


}