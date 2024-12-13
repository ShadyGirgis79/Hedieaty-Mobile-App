
import 'package:hedieaty/Model/Gift_Model.dart';
import 'Database/Database.dart';

class Event {
  String name;
  String category;
  String date;
  String status; // "Upcoming", "Current", or "Past"
  String location;
  String description;
  List<Gift> gifts;

  Event({
    required this.name,
    required this.category,
    required this.date,
    this.status = "Upcoming",
    this.location = "",
    this.description = "",
    this.gifts = const [],
  });

  final db = HedieatyDatabase();

  Future<int> insertEvent({
    required int id,
    required String name,
    String category = "General",
    required String date,
    required String status,
    String location ='',
    String description ='',
  }) async {
    String sql = '''
      INSERT INTO Events ('Name', 'Category', 'Date', 'Location', 'Description', 'Status' , 'UserID')
      VALUES ("$name", "$category", "$date", "$location", "$description", "$status" , "$id")
    ''';
    return await db.insertData(sql);
  }

  Future<List<Event>> getUserEvents(int userID) async {

    String sql = '''
    SELECT * FROM Events WHERE UserID = $userID
  ''';
    List<Map<String, dynamic>> result = await db.readData(sql);

    return result.map((data) {
      return Event(
        name: data['Name'],
        status: data['Status'],
        category: data['Category'],
        date: data['Date'],
        location: data['Location'],
        description: data['Description'],
      );
    }).toList();
  }

  Future<void> deleteEvent(String name) async{
    String sql = "DELETE FROM Events WHERE Name = '$name'";
    await db.deleteData(sql);
  }

}
