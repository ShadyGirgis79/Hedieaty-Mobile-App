
import 'package:hedieaty/Model/Gift_Model.dart';

class Event {
  String name;
  String category;
  DateTime date;
  String status; // "Upcoming", "Current", or "Past"
  String location;
  String description;
  List<Gift> gifts;

  Event({
    required this.name,
    required this.category,
    required this.date,
    required this.status,
    this.location = "",
    this.description = "",
    this.gifts = const [],
  });
}
