
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
      final eventsData = event.snapshot.value as Map<dynamic, dynamic>?;
      if (eventsData != null) {
        for (var event in eventsData.entries) {
          await localDB.insertData('''
            INSERT OR REPLACE INTO Events 
            (ID, Name, Category, Date, Location, Description, Status, Publish, UserID) 
            VALUES (
              ${int.parse(event.key)},
              '${event.value['name']}',
              '${event.value['category']}',
              '${event.value['date']}',
              '${event.value['location']}',
              '${event.value['description']}',
              '${event.value['status']}',
              ${event.value['publish'] ?? 0},
              ${event.value['userID']}
            );
          ''');
        }
        print("Events synced to local database");
      }
    });

    // Sync Gifts
    FirebaseDatabase.instance.ref('gifts').onValue.listen((event) async {
      final giftsData = event.snapshot.value as Map<dynamic, dynamic>?;
      if (giftsData != null) {
        for (var gift in giftsData.entries) {
          await localDB.insertData('''
            INSERT OR REPLACE INTO Gifts 
            (ID, Name, Category, Status, Price, Description, Image, Publish, EventID, PledgedID) 
            VALUES (
              ${int.parse(gift.key)},
              '${gift.value['name']}',
              '${gift.value['category']}',
              '${gift.value['status']}',
              ${gift.value['price'] ?? 0.0},
              '${gift.value['description']}',
              '${gift.value['image']}',
              ${gift.value['publish'] ?? 0},
              ${gift.value['eventID']},
              ${gift.value['pledgedID']}
            );
          ''');
        }
        print("Gifts synced to local database");
      }
    });

    // Sync Friends
    FirebaseDatabase.instance.ref('friends').onValue.listen((event) async {
      final friendsData = event.snapshot.value as Map<dynamic, dynamic>?;
      if (friendsData != null) {
        for (var friend in friendsData.entries) {
          await localDB.insertData('''
            INSERT OR REPLACE INTO Friends 
            (UserID, FriendID) 
            VALUES (
              ${friend.value['userID']},
              ${friend.value['friendID']}
            );
          ''');
        }
        print("Friends synced to local database");
      }
    });
  }
}
