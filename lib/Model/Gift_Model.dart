

import 'package:hedieaty/Model/Database/Database.dart';

class Gift {
  int? id;
  String name;
  String category;
  String status; // Pledged or Available
  String description;
  String imageURL;
  double price;


  Gift({
    this.id,
    required this.name,
    required this.category,
    required this.status,
    this.description="",
    this.imageURL="",
    required this.price});


  final db = HedieatyDatabase();

  Future<int> insertGift({
    required int EventId,
    required int PledgedId,
    required String name,
    required String category,
    required String status,
    required double price,
    String description ="",
    String image ="",
  }) async {
    String sql = '''
      INSERT INTO Gifts ('Name', 'Category', 'Status', 'Price', 'Description', 'Image' , 'EventID' , 'PledgedID')
      VALUES ("$name", "$category", "$status", "$price", "$description", "$image" , "$EventId" , "$PledgedId")
    ''';
    return await db.insertData(sql);
  }

  Future<List<Gift>> getEventGifts(int eventId) async {
    String sql = '''
    SELECT * FROM Gifts WHERE EventID = $eventId
    ''';
    List<Map<String, dynamic>> result = await db.readData(sql);

    return result.map((data) {
      return Gift(
        id: data['ID'],
        name: data['Name'],
        status: data['Status'],
        category: data['Category'],
        price: data['Price'],
        imageURL: data['Image'],
        description: data['Description'],
      );
    }).toList();
  }

  Future<void> deleteGift(String name , int id) async{
    String sql = '''
     DELETE FROM Gifts 
     WHERE Name = '$name' AND ID = '$id'
     ''';

    await db.deleteData(sql);
  }

// Update user data in the database
  Future<void> updateGift(String name ,String category ,String status, String image,
      String description, double price, int giftId) async {
    String sql = '''
      UPDATE Gifts
      SET Name = '$name',
          Category = '$category',
          Description = '$description',
          Status = '$status',
          Price = '$price',
          Image = '$image'
      WHERE ID = '$giftId';
    ''';

    await db.updateData(sql);
  }

  // Function to check if a gift is pledged
  Future<bool> isPledgedCheck(int giftId) async {
    try {
      String sql = '''
    SELECT PledgedID FROM Gifts WHERE ID = $giftId
    ''';

      // Execute the query
      List<Map<String, dynamic>> result = await db.readData(sql);

      // Check if the query returned any data
      if (result.isNotEmpty) {
        // Extract PledgedID from the result and check if it's non-zero
        int pledgedId = result.first['PledgedID'] ?? 0;
        return pledgedId != 0; // True if non-zero, false if zero
      }

      // If no rows are returned, consider it as not pledged (false)
      return false;

    }
    catch (e) {
      // Log the error (optional, use a logger if available)
      print('Error in isPledgedCheck: $e');
      // Return false in case of an error
      return false;
    }
  }

  Future<int> getPledgedUserID(int giftId) async{
    String sql = '''
    SELECT PledgedID FROM Gifts WHERE ID = $giftId
    ''';
    List<Map<String, dynamic>> result = await db.readData(sql);

    return result.first['PledgedID'];
  }

  Future<void> pledgeGift(int giftId , int userId) async{
    String sql = '''
      UPDATE Gifts
      SET Status = 'Pledged',
          PledgedID = '$userId'
      WHERE ID = '$giftId';
    ''';

    await db.updateData(sql);
  }

  Future<void> unpledgeGift(int giftId) async{
    String sql = '''
      UPDATE Gifts
      SET Status = 'Available',
          PledgedID = '0'
      WHERE ID = '$giftId';
    ''';

    await db.updateData(sql);

  }


  Future<List<Gift>> getUserPledgedGifts(int userId) async {
    String sql = '''
    SELECT * FROM Gifts 
    WHERE PledgedID = $userId AND Status = 'Pledged'
    ''';
    List<Map<String, dynamic>> result = await db.readData(sql);

    return result.map((data) {
      return Gift(
        id: data['ID'],
        name: data['Name'],
        status: data['Status'],
        category: data['Category'],
        price: data['Price'],
        imageURL: data['Image'],
        description: data['Description'],
      );
    }).toList();
  }


}




