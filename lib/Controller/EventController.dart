

import 'package:firebase_auth/firebase_auth.dart';
import '../Model/Event_Model.dart';

class EventController{
  final Event eventModel= Event(name: "", category: "", date: "");
  final String currentUserID = FirebaseAuth.instance.currentUser!.uid;

  Future<List<Event>?> eventsList() async{
    try {
      final int hashedID = currentUserID.hashCode;
      return await eventModel.getUserEvents(hashedID);
    }
    catch (e) {
      print("Error fetching user from local DB: $e");
      return null;
    }
  }

  Future<String> DeleteEvent(String name) async{
    await eventModel.deleteEvent(name);
    return "$name event has been deleted";
  }

  Future<List<Event>> getFriendEvents(int friendID) async {
    try {
      return await eventModel.getUserEvents(friendID);
    }
    catch (e) {
      print("Error fetching friend events from local DB: $e");
      return [];
    }
  }

  Future<String> UpdateEvent(String name, String category , String description,
      String location , int id) async{
    try {
      await eventModel.updateEvent(name, category, description, location, id);

      return "Event updated successfully!";

    }
    catch (e) {
      // Handle any errors
      return "Failed to update event: $e";
    }
  }

}