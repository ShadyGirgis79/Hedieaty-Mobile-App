
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
            (ID, Name, Email, Preferences, Password, ProfileURL, PhoneNumber) 
            VALUES (
              ${int.parse(user.key)},
              '${user.value['name']}',
              '${user.value['email']}',
              '${user.value['preference']}',
              '${user.value['password']}',
              '${user.value['profileURL']}',
              '${user.value['phone']}'
            );
          ''');
        }
        print("Users synced to local database");
      }
    });

    // Sync Events
    FirebaseDatabase.instance.ref('events').onValue.listen((event) async {
      final eventsData = event.snapshot.value;

      if (eventsData is Map) {
        // Iterate over the map
        eventsData.forEach((key, event) async {
          if (event != null) {
            await localDB.insertData('''
          INSERT OR REPLACE INTO Events 
          (ID, Name, Category, Date, Location, Description, Status, Publish, UserID) 
          VALUES (
            '${key}', 
            '${event['name'] ?? ''}', 
            '${event['category'] ?? ''}', 
            '${event['date'] ?? ''}', 
            '${event['location'] ?? ''}', 
            '${event['description'] ?? ''}', 
            '${event['status'] ?? ''}', 
            ${event['publish'] ?? 0}, 
            ${event['UserId'] ?? 0}
          );
        ''');
          }
        });
      }
      else{
        if (eventsData is List) {
          // Handle as List
          for (int index = 0; index < eventsData.length; index++) {
            var event = eventsData[index];
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
      }

      print("Events synced to local database");
    });

    // Sync Gifts
    FirebaseDatabase.instance.ref('gifts').onValue.listen((event) async {
      final giftsData = event.snapshot.value;

      if (giftsData is List) {
        // Handle data as List
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
            ${gift['EventId'] ?? 'NULL'},
            ${gift['PledgedId'] ?? 'NULL'}
          );
        ''');
          }
        }
      }
      else if (giftsData is Map) {
        // Handle data as Map
        giftsData.forEach((key, gift) async {
          if (gift != null) {
            await localDB.insertData('''
          INSERT OR REPLACE INTO Gifts 
          (ID, Name, Category, Status, Price, Description, Image, Publish, EventID, PledgedID) 
          VALUES (
            $key,
            '${gift['name']}',
            '${gift['category']}',
            '${gift['status']}',
            ${gift['price'] ?? 0.0},
            '${gift['description']}',
            '${gift['image']}',
            ${gift['publish'] ?? 0},
            ${gift['EventId'] ?? 'NULL'},
            ${gift['PledgedId'] ?? 'NULL'}
          );
        ''');
          }
        });
      }
      else {
        print("Gifts data is in an unsupported format: ${giftsData.runtimeType}");
      }

      print("Gifts synced to local database");
    });

    // Sync Friends
    FirebaseDatabase.instance.ref('friends').onValue.listen((event) async {
      final friendsData = event.snapshot.value;

      if (friendsData is List) {
        // Handle data as List
        for (int i = 0; i < friendsData.length; i++) {
          var friend = friendsData[i];
          if (friend != null) { // Avoid null entries in the list
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
      else if (friendsData is Map) {
        // Handle data as Map
        friendsData.forEach((key, friend) async {
          if (friend != null) { // Avoid null entries in the map
            await localDB.insertData('''
          INSERT OR REPLACE INTO Friends 
          (ID, UserID, FriendID) 
          VALUES (
            ${key},  
            ${friend['UserId']},
            ${friend['FriendId']}
          );
        ''');
          }
        });
      }
      else {
        print("Friends data is in an unsupported format: ${friendsData.runtimeType}");
      }
    });

    // Sync Notifications
    FirebaseDatabase.instance.ref('notifications').onValue.listen((event) async {
      final notificationsData = event.snapshot.value;
      //If the data is in form of Map
      if (notificationsData is Map) {
        notificationsData.forEach((key, notification) async {
          if (notification != null) { // Avoid null entries
            await localDB.insertData('''
          INSERT OR REPLACE INTO Notifications 
          (ID, UserID, Message) 
          VALUES (
            '${key}',  
            ${notification['UserId'] ?? 0}, 
            '${notification['message'] ?? ''}'
          );
        ''');
          }
        });
      }
      else{
        //If the data is in form of List
        if (notificationsData is List) {
          // Handle data as List
          for (int i = 0; i < notificationsData.length; i++) {
            var notification = notificationsData[i];
            if (notification != null) {// Avoid null entries in the list
              await localDB.insertData('''
          INSERT OR REPLACE INTO Notifications 
          (ID, UserID, Message) 
          VALUES (
            ${i},  
            ${notification['UserId']},
            ${notification['message']}
          );
        ''');
            }
          }
        }
      }

      print("Notifications synced to local database");
    });



  }
}
