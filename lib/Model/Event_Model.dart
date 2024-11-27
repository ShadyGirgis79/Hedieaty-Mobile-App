
import 'package:hedieaty/Model/Gift_Model.dart';

class Event {
  String name;
  String category;
  DateTime date;
  String status; // "Upcoming", "Current", or "Past"
  List<Gift> gifts;

  Event({
    required this.name,
    required this.category,
    required this.date,
    required this.status,
    this.gifts = const [],
  });
}
