

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hedieaty/Model/Event_Model.dart';

class AddEventController{

  late final Event eventModel;
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  final String currentUserID = FirebaseAuth.instance.currentUser!.uid;

  Future<String?> addEvent({
    required String name,
    required String category,
    String description = "",
    String location = "",
    required String date,
    required String status,
  }) async {
    if (name.isEmpty || date.isEmpty) {
      return "Please fill out all fields";
    }

    try {
      // Create the Event object
      Event newEvent = Event(
        name: name,
        category: category,
        date: date,
        status: status,
        location: location,
        description: description,
      );

      // Insert event into local database
      int response = await newEvent.insertEvent(
        id: currentUserID.hashCode,
        name: name,
        category: category,
        date: date,
        status: status,
        location: location,
        description: description,
      );

      if (response > 0) {
        return null; // Successfully added
      } else {
        return "Failed to add event to local database";
      }
    } catch (e) {
      return "An error occurred: $e";
    }
  }

}