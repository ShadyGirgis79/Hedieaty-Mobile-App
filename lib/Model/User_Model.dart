
import 'package:hedieaty/Model/Event_Model.dart';
import 'package:hedieaty/Model/Database/Database.dart';

class User{
  int? id;
  String name;
  String password;
  String profileURL;
  String phoneNumber;
  String email;
  String preference;
  List<Event> events;

  User({
    this.id,
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
        id: data['ID'], // Include ID from the database
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

  static Future<User?> fetchUserByID(int id) async {
    final db = HedieatyDatabase();
    final response = await db.readData(
      "SELECT * FROM Users WHERE ID = '$id' ",
    );

    if (response.isNotEmpty) {
      final data = response.first;
      return User(
        id: data['ID'], // Include ID from the database
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

  static Future<User?> fetchUserByNameAndPhone(String name , String phone) async {
    final db = HedieatyDatabase();
    final response = await db.readData(
      "SELECT * FROM Users WHERE Name = '$name' AND PhoneNumber = '$phone' ",
    );

    if (response.isNotEmpty) {
      final data = response.first;
      return User(
        id: data['ID'], // Include ID from the database
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
  Future<void> updateUser(String name,String profileURL , String phone, String pref,
      String email , String pass) async {
    String sql='''
    UPDATE Users
    SET Name = '$name',
        ProfileURL = '$profileURL',
        PhoneNumber = '$phone',
        Preferences = '$pref'
    WHERE Email = '$email' AND Password = '$pass';
    ''';
    await db.updateData(sql);
  }

  Future<Map<String, dynamic>?> getUserByPhoneNumber(String phoneNumber) async {
    String sql = '''
      SELECT * FROM Users WHERE PhoneNumber = "$phoneNumber"
    ''';
    List<Map<String, dynamic>> result = await db.readData(sql);
    return result.isNotEmpty ? result.first : null;
  }

// Add a friend relationship
  Future<void> addFriend(int userId, int friendId) async {
    String sql = '''
      INSERT INTO Friends (UserID, FriendID)
      VALUES ("$userId", "$friendId")
    ''';
    await db.insertData(sql);
  }

  Future<int> updateUserID(String email, String password, int newId) async {
    String sql = '''
    UPDATE Users SET ID = "$newId"
    WHERE Email = "$email" AND Password = "$password"
    ''';
    return await db.updateData(sql);
  }

  Future<bool> checkIfFriends(int userId, int friendId) async {
    String sql = '''
    SELECT * FROM Friends WHERE UserID = $userId AND FriendID = $friendId
  ''';
    List<Map<String, dynamic>> result = await db.readData(sql);
    return result.isNotEmpty;
  }

  Future<List<User>> getFriends(int userId) async {
    String sql = '''
    SELECT U.* FROM Users U
    INNER JOIN Friends F ON U.ID = F.FriendID
    WHERE F.UserID = $userId
  ''';
    List<Map<String, dynamic>> result = await db.readData(sql);

    return result.map((data) {
      return User(
        id: data['ID'],
        name: data['Name'],
        email: data['Email'],
        password: data['Password'],
        profileURL: data['ProfileURL'] ?? '',
        phoneNumber: data['PhoneNumber'],
        preference: data['Preferences'] ?? '',
      );
    }).toList();
  }

  Future<void> deleteUser(String name) async{
    String sql = "DELETE FROM Users WHERE Name = '$name'";
    await db.deleteData(sql);
  }

  Future<void> updateProfileImage(String profileURL , int userId) async {
    String sql ='''
      UPDATE Users
      SET ProfileURL = '$profileURL'
      WHERE ID = '$userId' ;
      ''';
    await db.updateData(sql);
  }

}




