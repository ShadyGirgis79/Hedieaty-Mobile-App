
import 'package:firebase_database/firebase_database.dart';
import 'package:hedieaty/Model/Database/Database.dart';


class SyncFirebaseAndLocalDB {
  final HedieatyDatabase localDB = HedieatyDatabase();

  // Listen for Firebase data changes and sync to SQLite
  Future<void> syncFirebaseToLocalDB() async {
    // Sync Users
    FirebaseDatabase.instance.ref('users').onValue.listen((event) async {
      final usersData = event.snapshot.value as Map<dynamic, dynamic>?;
      if (usersData != null) {
        for (var user in usersData.entries) {
          await localDB.insertData('''
            INSERT OR REPLACE INTO Users 
            (ID, Name, Email, Preferences, Password, ProfileURL, PhoneNumber, Notifications) 
            VALUES (
              ${int.parse(user.key)},
              '${user.value['name']}',
              '${user.value['email']}',
              '${user.value['preference']}',
              '${user.value['password']}',
              '${user.value['profileURL']}',
              '${user.value['phone']}',
              0
            );
          ''');
        }
        print("Users synced to local database");
      }
    });

    // Sync Events
    FirebaseDatabase.instance.ref('events').onValue.listen((event) async {
      final eventsData = event.snapshot.value;
      if (eventsData is List) {
        // Handle as List
        for (int index = 0; index < eventsData.length; index++) {
          final event = eventsData[index];
          if (event != null) {
            await localDB.insertData('''
            INSERT OR REPLACE INTO Events 
            (ID, Name, Category, Date, Location, Description, Status, Publish, UserID) 
            VALUES (
              $index,
              '${event['name']}',
              '${event['category']}',
              '${event['date']}',
              '${event['location']}',
              '${event['description']}',
              '${event['status']}',
              ${event['publish'] ?? 0},
              ${event['UserId']}
            );
          ''');
          }
        }
      }
      print("Events synced to local database");
    });

    // Sync Gifts
    FirebaseDatabase.instance.ref('gifts').onValue.listen((event) async {
      final giftsData = event.snapshot.value;
      if (giftsData is List) {
        // Handle as List
        for (int index = 0; index < giftsData.length; index++) {
          final gift = giftsData[index];
          if (gift != null) {
            await localDB.insertData('''
            INSERT OR REPLACE INTO Gifts 
            (ID, Name, Category, Status, Price, Description, Image, Publish, EventID, PledgedID) 
            VALUES (
              $index,
              '${gift['name']}',
              '${gift['category']}',
              '${gift['status']}',
              ${gift['price'] ?? 0.0},
              '${gift['description']}',
              '${gift['image']}',
              ${gift['publish'] ?? 0},
              ${gift['EventId']},
              ${gift['PledgedId']}
            );
          ''');
          }
        }
      }
      print("Gifts synced to local database");
    });

    // Sync Friends
    // Sync Friends
    FirebaseDatabase.instance.ref('friends').onValue.listen((event) async {
      final friendsData = event.snapshot.value;
      if (friendsData is List<dynamic>) {
        // Handle data as List
        for (int i = 0; i < friendsData.length; i++) {
          var friend = friendsData[i];
          if (friend != null) {// Avoid null entries in the list
            await localDB.insertData('''
          INSERT OR REPLACE INTO Friends 
          (ID, UserID, FriendID) 
          VALUES (
            ${i},  
            ${friend['UserId']},
            ${friend['FriendId']}
          );
        ''');
          }
        }
      }
      else {
        print("Friends data is in an unsupported format: ${friendsData.runtimeType}");
      }

      print("Friends synced to local database");
    });
  }
}
