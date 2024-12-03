



import 'package:hedieaty/Model/Event_Model.dart';

class User {
  String name;
  String password;
  String profileURL;
  String phoneNumber;
  String email;
  String preference;
  List<Event> events;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.profileURL,
    required this.phoneNumber ,
    this.preference='',
    this.events = const []});

}