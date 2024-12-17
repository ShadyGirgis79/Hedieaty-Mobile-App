
import 'package:hedieaty/Model/Database/Database.dart';

class Friends{
  int? id;
  int UserId;
  int FriendId;

  Friends({
    required this.UserId ,
    required this.FriendId
  });

  final db = HedieatyDatabase();

  Future<bool> checkIfFriends(int userId, int friendId) async {
    String sql = '''
    SELECT * FROM Friends WHERE UserID = $userId AND FriendID = $friendId
  ''';
    List<Map<String, dynamic>> result = await db.readData(sql);
    return result.isNotEmpty;
  }

  // Add a friend relationship
  Future<void> addFriend(int userId, int friendId) async {
    String sql = '''
      INSERT INTO Friends (UserID, FriendID)
      VALUES ("$userId", "$friendId")
    ''';
    await db.insertData(sql);
  }

  Future<List<Map>> getAllFriends() async {
    return await db.readData("SELECT * FROM Friends");
  }

}