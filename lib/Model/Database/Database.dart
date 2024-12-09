
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HedieatyDatabase{

  static Database? _MyDatabase;

  Future<Database?> get MyDataBase async {
    if (_MyDatabase == null) {
      _MyDatabase = await initialize();
      return _MyDatabase;
    }
    else {
      return _MyDatabase;
    }
  }
  int Version = 1;
  //int Version = 2;  // Change the version to 2

  initialize() async {
    String mypath = await getDatabasesPath();
    String path = join(mypath, "myDataBase.db");

    checking();
    //For deleting Database
    //deleteDB();

    Database mydb = await openDatabase(path, version: Version,
        onCreate: (db, Version) async {

          //Create Users Table
          await db.execute('''
          CREATE TABLE IF NOT EXISTS 'Users' (
            'ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            'Name' TEXT UNIQUE NOT NULL,
            'Email' TEXT UNIQUE NOT NULL,
            'Preferences' TEXT,
            'Password' TEXT NOT NULL,
            'ProfileURL' TEXT ,
            'PhoneNumber' TEXT UNIQUE NOT NULL,
            'Notifications' BOOLEAN DEFAULT 0
            );
          ''');
          //'UpcomingEvents' INTEGER DEFAULT 0,


          //Create Events Table
          await db.execute('''
          CREATE TABLE IF NOT EXISTS 'Events' (
            'ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            'Name' TEXT NOT NULL,
            'Category' TEXT NOT NULL,
            'Date' TEXT NOT NULL,
            'Location' TEXT,
            'Description' TEXT,
            'Status' TEXT NOT NULL,
            'UserID' INTEGER NOT NULL,
            FOREIGN KEY (UserID) REFERENCES Users (ID) ON DELETE CASCADE
          );
          ''');


          //Create Gifts Table
          await db.execute('''
          CREATE TABLE IF NOT EXISTS 'Gifts' (
            'ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            'Name' TEXT NOT NULL,
            'Category' TEXT NOT NULL,
            'Status' TEXT NOT NULL,
            'Price' REAL,
            'Description' TEXT NOT NULL,
            'Image' TEXT NOT NULL,
            'EventID' INTEGER NOT NULL,
            'PledgedID' INTEGER NOT NULL,
            FOREIGN KEY (PledgedID) REFERENCES Users (ID) ON DELETE CASCADE,
            FOREIGN KEY (EventID) REFERENCES Events (ID) ON DELETE CASCADE
          );
          ''');

          //FOREIGN KEY (PledgedID) REFERENCE Users (ID) ON DELETE CASCADE,

          await db.execute('''
          CREATE TABLE IF NOT EXISTS 'Friends' (
            'UserID' INTEGER NOT NULL,
            'FriendID' INTEGER NOT NULL,
            PRIMARY KEY(userID, friendID),
            FOREIGN KEY(userID) REFERENCES Users(ID),
            FOREIGN KEY(friendID) REFERENCES Users(ID)
          );
          ''');


          print("Database has been created .......");
        },
        );

    checking();

    return mydb;
  }

  readData(String SQL) async {
    Database? mydata = await MyDataBase;
    var response = await mydata!.rawQuery(SQL);
    return response;
  }

  insertData(String SQL) async {
    Database? mydata = await MyDataBase;
    int response = await mydata!.rawInsert(SQL);

    print("=========================== The data is inserted successfully.............");
    return response;
  }

  deleteData(String SQL) async {
    Database? mydata = await MyDataBase;
    int response = await mydata!.rawDelete(SQL);
    return response;
  }

  updateData(String SQL) async {
    Database? mydata = await MyDataBase;
    int response = await mydata!.rawUpdate(SQL);
    return response;
  }

  mydeletedatabase() async {
    String database = await getDatabasesPath();
    String Path = join(database, 'myDataBase.db');
    bool ifitexist = await databaseExists(Path);
    if (ifitexist == true) {
      print('it exist');
    }
    else {
      print("it doesn't exist");
    }
    await deleteDatabase(Path);
    print("MyData has been deleted");
  }

  checking() async{
    String database = await getDatabasesPath();
    String Path = join(database, 'myDataBase.db');
    if (await databaseExists(Path)) {
      print('it exist  ======================');
    }
    else {
      print("it doesn't exist  ========================");
    }
  }

  deleteDB() async{
    String database = await getDatabasesPath();
    String Path = join(database, 'myDataBase.db');
    await deleteDatabase(Path);
    print("MyData has been deleted..........");
  }

  // Method to query users
  Future<List<Map<String, dynamic>>> queryUsers() async {
    Database? mydata = await MyDataBase; // Get the Database instance via the getter
    return await mydata!.query('Users'); // Query the 'Users' table
  }

}