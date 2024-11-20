
class Event {
  String name;
  String category;
  String status; // "Upcoming", "Current", or "Past"
  int gifts;

  Event({
    required this.name,
    required this.category,
    required this.status,
    required this.gifts});
}
