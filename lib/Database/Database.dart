
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

  initialize() async {
    String mypath = await getDatabasesPath();
    String path = join(mypath, "myDataBase.db");
    Database mydb = await openDatabase(path, version: Version,
        onCreate: (db, Version) async {

          //Create Users Table
          await db.execute('''
          CREATE TABLE IF NOT EXISTS 'Users' (
            'ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            'Name' TEXT NOT NULL,
            'Password' TEXT NOT NULL,
            'ProfileURL' TEXT NOT NULL,
            'PhoneNumber' TEXT NOT NULL
            );
          ''');

          //Create Events Table
          await db.execute('''
          CREATE TABLE IF NOT EXISTS 'Events' (
            'ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            'Name' TEXT NOT NULL,
            'Category' TEXT NOT NULL,
            'Date' TEXT NOT NULL,
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
            'Price' INTEGER NOT NULL,
            'Image' TEXT NOT NULL,
            'EventID' INTEGER NOT NULL,
            FOREIGN KEY (EventID) REFERENCES Events (ID) ON DELETE CASCADE
          );
          ''');

          print("Database has been created .......");
        });
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

    print("The data is inserted successfully.............");
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
    } else {
      print("it doesn't exist");
    }
    await deleteDatabase(Path);
    print("MyData has been deleted");
  }

}