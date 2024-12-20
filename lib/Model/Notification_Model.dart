
import 'package:hedieaty/Model/Database/Database.dart';

class Notifications{
  int? id;
  int? UserId;
  String message;

  Notifications({
    this.id,
    this.UserId,
    required this.message
  });

  final db = HedieatyDatabase();

  Future<void> insertNotification({
    required int UserId,
    required String message,
  }) async {
    String sql = '''
      INSERT INTO Notifications ('UserID', 'Message')
      VALUES ("$UserId", "$message")
    ''';
    await db.insertData(sql);
  }

  Future<void> deleteNotification(int id) async{
    String sql = '''
     DELETE FROM Notifications 
     WHERE ID = '$id'
     ''';

    await db.deleteData(sql);
  }

  Future<void> deleteAllNotifications(int userId) async{
    String sql = '''
     DELETE FROM Notifications 
     WHERE UserID = '$userId'
     ''';

    await db.deleteData(sql);
  }

  Future<List<Notifications>> getUserNotifications(int UserId) async {
    String sql = '''
    SELECT * FROM Notifications 
    WHERE UserID = $UserId 
    ''';
    List<Map<String, dynamic>> result = await db.readData(sql);

    return result.map((data) {
      return Notifications(
        id: data['ID'],
        UserId: data['UserID'],
        message: data['Message'],
      );
    }).toList();
  }

  Future<List<Map>> getAllNotifications() async {
    return await db.readData("SELECT * FROM Notifications");
  }

}