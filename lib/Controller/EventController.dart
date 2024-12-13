

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

  Future<String> Delete(String name) async{
    await eventModel.deleteEvent(name);
    return "$name event has been deleted ";
  }
}