

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../Model/Event_Model.dart';

class EventController{
  final Event eventModel= Event(name: "", category: "", date: "");
  final String currentUserID = FirebaseAuth.instance.currentUser!.uid;
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  Future<List<Event>?> eventsList() async{
    try {
      final int hashedID = currentUserID.hashCode;
      return await eventModel.getUserEvents(hashedID);
    }
    catch (e) {
      print("Error fetching events from local Database: $e");
      return null;
    }
  }

  Future<String> DeleteEvent(String name , int id) async{
    //Delete from Local Database
    await eventModel.deleteEvent(name , id);
    await eventModel.deleteGiftsBelongToEvent(id);

    final giftsRef = databaseRef.child('gifts'); // Assuming gifts are stored here
    final giftsSnapshot = await giftsRef.get();

    if (giftsSnapshot.exists) {
      final giftsData = giftsSnapshot.value;
      if (giftsData is List) {
        // Handle gifts stored as a List in Firebase
        for (int index = 0; index < giftsData.length; index++) {
          final gift = giftsData[index];
          if (gift != null && gift['EventId'] == id) {
            // Use the index as the key for deletion in Firebase
            await giftsRef.child(index.toString()).remove();
          }
        }
      }
    }

    //Delete from Firebase
    await databaseRef.child('events').child(id.toString()).remove();
    return "$name event has been deleted";
  }

  Future<List<Event>> getFriendEvents(int friendID) async {
    try {
      return await eventModel.getFriendsEvents(friendID);
    }
    catch (e) {
      print("Error fetching friend events from local DB: $e");
      return [];
    }
  }

  Future<String> UpdateEvent(String name, String category , String description,
      String location ,String date, String status , int id) async{
    try {
      //Update in Local Database
      await eventModel.updateEvent(name, category, description, location, date, status, id);

      // Update event in Firebase
      await databaseRef.child('events').child(id.toString()).update({
        'name': name,
        'category': category,
        'description': description,
        'location': location,
        'date': date,
        'status': status,
      });
      return "${name} event is updated successfully!";
    }
    catch (e) {
      // Handle any errors
      return "Failed to update event: $e";
    }
  }

  Future<void> MakeEventPublic(int id) async{
    try {
      // Make Event public in Local Database
      await eventModel.makeEventPublic(id);

      // Make Event public in Firebase
      await databaseRef.child('events').child(id.toString()).update({
        'publish': 1,
      });
    }
    catch (e) {
      // Handle any errors
      print("Failed to update event: $e");
    }
  }

  Future<void> UpdateEventStatus(int id , String status) async{
    try {
      //Update Event Status in Local Database
      await eventModel.changeEventStatus(id, status);

      // Update Event Status in Firebase
      await databaseRef.child('events').child(id.toString()).update({
        'status': status,
      });
    }
    catch (e) {
      // Handle any errors
      print("Failed to update event: $e");
    }
  }

}