

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hedieaty/Model/Event_Model.dart';

class AddEventController{

  final Event eventModel = Event(name: '', category: '', date: '');
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  final String currentUserID = FirebaseAuth.instance.currentUser!.uid;

  Future<String?> addEvent({
    required String name,
    String category = "General",
    String description = "",
    String location = "",
    required String date,
    required String status,
  }) async {
    if (name.isEmpty || date.isEmpty) {
      return "Please fill out at least the name and date";
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
        UserId: currentUserID.hashCode,
        name: name,
        category: category,
        date: date,
        status: status,
        location: location,
        description: description,
        publish: 0,
      );

      if (response > 0) {
        return null; // Successfully added
      }
      else {
        return "Failed to add event to local database";
      }
    }
    catch (e) {
      return "An error occurred: $e";
    }
  }

  Future<String?> addEventPublic({
    required String name,
    String category = "General",
    String description = "",
    String location = "",
    required String date,
    required String status,
  }) async {
    if (name.isEmpty || date.isEmpty) {
      return "Please fill out at least the name and date";
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
        UserId: currentUserID.hashCode,
        name: name,
        category: category,
        date: date,
        status: status,
        location: location,
        description: description,
        publish: 1,
      );

      await addEventsFirebase();

      if (response > 0) {
        return null; // Successfully added
      }
      else {
        return "Failed to add event to local database";
      }
    }
    catch (e) {
      return "An error occurred: $e";
    }
  }


  Future<void> addEventsFirebase() async{

    List<Map> events = await eventModel.getAllEvents();

    for (var event in events){
      int id = event['ID'];
      String name = event['Name'];
      String category = event['Category'];
      String date = event['Date'];
      String location = event['Location'];
      String description = event['Description'];
      String status = event['Status'];
      int publish = event['Publish'];
      int userId = event['UserID'];

      DatabaseReference eventsRef = databaseRef.child('events').child(id.toString());
      await eventsRef.set({
        'name': name,
        'category': category,
        'description':description,
        'status': status,
        'date': date,
        'location': location,
        'publish': publish,
        'UserId': userId,
      });
    }
  }
}