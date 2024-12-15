

import 'package:hedieaty/Model/Database/Database.dart';

class Gift {
  int? id;
  String name;
  String category;
  String status; // Pledged or Unpledged
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
}

final db = HedieatyDatabase();

Future<int> insertGift({
  required int EventId,
  required String name,
  required String category,
  required String status,
  required double price,
  String description ="",
  String image ="",
}) async {
  String sql = '''
      INSERT INTO Events ('Name', 'Category', 'Status', 'Price', 'Description', 'Image' , 'EventID')
      VALUES ("$name", "$category", "$status", "$price", "$description", "$image" , "$EventId")
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
Future<void> updateGift(String name ,String category , String image,
    String description, int price, int id) async {
  await db.updateData('''
      UPDATE Events
      SET Name = '$name',
          Category = '$category',
          Description = '$description',
          Price = '$price',
          Image = '$image'
      WHERE ID = '$id';
    ''');
}
