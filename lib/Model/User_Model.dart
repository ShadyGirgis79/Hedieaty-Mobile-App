



import 'package:hedieaty/Model/Event_Model.dart';

class User {
  String name;
  String password;
  String profileURL;
  String phoneNumber;
  List<Event> events;

  User({
    required this.name,
    required this.password,
    required this.profileURL,
    required this.phoneNumber ,
    this.events = const []});

}