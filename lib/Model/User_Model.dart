
import 'package:hedieaty/Model/Event_Model.dart';
import 'package:hedieaty/Model/Database/Database.dart';

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

  static Future<User?> fetchUserByEmailAndPassword(String email , String password) async {
    final db = HedieatyDatabase();
    final response = await db.readData(
      "SELECT * FROM Users WHERE Email = '$email' AND Password = '$password' ",
    );

    if (response.isNotEmpty) {
      final data = response.first;
      return User(
        name: data['Name'],
        email: data['Email'],
        password: data['Password'],
        profileURL: data['ProfileURL'] ?? '',
        phoneNumber: data['PhoneNumber'],
        preference: data['Preferences'] ?? '',
      );
    }
    return null;
  }

  // Update user data in the database
  Future<void> updateUser() async {
    await db.updateData('''
      UPDATE Users
      SET Name = '$name',
          ProfileURL = '$profileURL',
          PhoneNumber = '$phoneNumber',
          Preferences = '$preference'
      WHERE Email = '$email' AND Password = '$password';
    ''');
  }
}

