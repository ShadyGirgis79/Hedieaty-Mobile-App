import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hedieaty/Model/Gift_Model.dart';

class AddGiftController {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  final String currentUserID = FirebaseAuth.instance.currentUser!.uid;
  final Gift giftModel = Gift(name: "", category: "", status: "", price: 0);

  // Add a gift to the local SQLite database
  Future<String?> addGift({
    required String name,
    required String category,
    String description = "",
    String image = "",
    required double price,
    required String status,
    required int eventId,
    required int pledgedId
  }) async {
    // Validate fields
    if (name.isEmpty || price <= 0) {
      return "Please fill all fields correctly.";
    }
    try {
      // Create a Gift instance
      Gift newGift = Gift(
        name: name,
        category: category,
        status: status,
        price: price,
        imageURL: image,
        description: description,
      );

      // Insert into local database using the model's `insertGift` function
      int response = await newGift.insertGift(
        EventId: eventId,
        name: name,
        category: category,
        status: status,
        price: price,
        image: image,
        description: description,
        PledgedId: pledgedId,
        publish: 0,
      );

      await addGiftsFirebase();

      if (response > 0) {
        return null;
      }
      else {
        return "Failed to save the gift.";
      }
    }
    catch (e) {
      return "An error occurred: $e";
    }
  }

  // Add a gift to the local SQLite database
  Future<String?> addGiftPublic({
    required String name,
    required String category,
    String description = "",
    String image = "",
    required double price,
    required String status,
    required int eventId,
    required int pledgedId
  }) async {
    // Validate fields
    if (name.isEmpty || price <= 0) {
      return "Please fill all fields correctly.";
    }
    try {
      // Create a Gift instance
      Gift newGift = Gift(
        name: name,
        category: category,
        status: status,
        price: price,
        imageURL: image,
        description: description,
      );

      // Insert into local database using the model's `insertGift` function
      int response = await newGift.insertGift(
        EventId: eventId,
        name: name,
        category: category,
        status: status,
        price: price,
        image: image,
        description: description,
        PledgedId: pledgedId,
        publish: 1,
      );

      await addGiftsFirebase();

      if (response > 0) {
        return null;
      }
      else {
        return "Failed to save the gift.";
      }
    }
    catch (e) {
      return "An error occurred: $e";
    }
  }

  Future<void> addGiftsFirebase() async{

    List<Map> gifts = await giftModel.getAllGifts();

    for (var gift in gifts){
      int id = gift['ID'];
      String name = gift['Name'];
      String category = gift['Category'];
      String description = gift['Description'];
      String status = gift['Status'];
      String image = gift['Image'];
      double price = gift['Price'];
      int publish = gift['Publish'];
      int eventId = gift['EventID'];
      int pledgedId = gift['PledgedID'];

      DatabaseReference eventsRef = databaseRef.child('gifts').child(id.toString());
      await eventsRef.set({
        'name': name,
        'category': category,
        'description':description,
        'status': status,
        'image': image,
        'price': price,
        'publish': publish,
        'EventId': eventId,
        'PledgedId': pledgedId,
      });
    }
  }

}