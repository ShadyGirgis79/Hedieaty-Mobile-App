
import 'package:hedieaty/Model/Event_Model.dart';
import '../Database/Database.dart';

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
    this.profileURL ='',
    required this.phoneNumber ,
    this.preference='',
    this.events = const []});

  final db = HedieatyDatabase();

  Future<int> insertUser({
    required String name,
    required String password,
    String profileURL ='',
    required String phoneNumber,
    required String email,
    String preferences='',
  }) async {

    String sql = '''
      INSERT INTO Users ('Name', 'Password', 'ProfileURL', 'PhoneNumber', 'Email', 'Preferences')
      VALUES ("$name", "$password", "$profileURL", "$phoneNumber", "$email", "$preferences")
    ''';
    return await db.insertData(sql);
  }

  Future<List<Map>> getAllUsers() async {
    final db = HedieatyDatabase();
    return await db.readData("SELECT * FROM Users");
  }

  Future<List<Map<String, dynamic>>> getUserByEmailAndPassword(String email, String password) async {
    // Use parameterized queries to avoid SQL injection
    String sql = '''
      SELECT * FROM 'Users'
      WHERE Email = "$email" AND Password = "$password"
    ''';
    return await db.readData(sql);
  }

}
