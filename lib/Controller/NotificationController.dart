

import 'package:firebase_database/firebase_database.dart';
import 'package:hedieaty/Model/Notification_Model.dart';

class  NotificationController{
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  final Notifications notificationModel = Notifications(message: '');

  Future<List<Notifications>?> notificationsList(int userId) async {
    try{
      return await notificationModel.getUserNotifications(userId);
    }
    catch (e) {
      print("Error fetching notifications local DB: $e");
      return null;
    }
  }

  Future<void> addMessage(int UserId , String message) async{
    try{
      await notificationModel.insertNotification(UserId:UserId , message:message);

      await addNotificationFirebase();
    }
    catch (e) {
      print("Error fetching notifications local DB: $e");
      return null;
    }
  }

  Future<void> addNotificationFirebase() async{

    List<Map> notifications = await notificationModel.getAllNotifications();

    for (var not in notifications){
      int id = not['ID'];
      int userId = not['UserID'];
      String message = not['Message'];

      DatabaseReference eventsRef = databaseRef.child('notifications').child(id.toString());
      await eventsRef.set({
        'UserId': userId,
        'message': message,
      });
    }
  }

  Future<void> clearAllMessages(int userId) async {
    // Delete all notifications from local database
    await notificationModel.deleteAllNotifications(userId);

    // Delete all notifications from Firebase
    final notsRef = databaseRef.child('notifications'); // Assuming gifts are stored here
    final notsSnapshot = await notsRef.get();

    if (notsSnapshot.exists) {
      final notsData = notsSnapshot.value;
      if (notsData is Map) {
        // Handle notifications stored as a Map in Firebase
        notsData.forEach((key, value) async {
          if (value != null && value['UserId'] == userId) {
            // Delete the notification with the matching userId
            await notsRef.child(key.toString()).remove();
          }
        });
      }
    }

  }

  Future<void> clearMessage(int id) async {
    //Delete notification from local database
    await notificationModel.deleteNotification(id);

    // Delete notification from Firebase
    await databaseRef.child('notifications').child(id.toString()).remove();
  }

}