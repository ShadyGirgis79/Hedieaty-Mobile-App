
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/Controller/NotificationController.dart';
import 'package:hedieaty/Model/Notification_Model.dart';


class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final String currentUserID = FirebaseAuth.instance.currentUser!.uid;
  final NotificationController notificationController = NotificationController();
  List<Notifications> notifications = [];

  void clearAll(int userId) async {
    await notificationController.clearAllMessages(userId);
    setState(() {
      notifications.clear(); // Clear the entire list
    });
    loadNotifications();
  }


  @override
  void initState() {
    super.initState();
    loadNotifications(); // Load gifts when the page is initialized
  }

  Future<void> loadNotifications() async {
    final fetchedNotifications = await notificationController.notificationsList(currentUserID.hashCode);
    setState(() {
      notifications = fetchedNotifications ?? [];
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.purpleAccent[700],
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<int>(
            onSelected: clearAll,
            itemBuilder: (context) => [
              PopupMenuItem(value: currentUserID.hashCode ,child: Text("Clear All")),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
            ),
            Expanded(
              child: notifications.isEmpty
                  ? Center(
                child: Text(
                  'No Notifications yet.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              )
                  :  ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Dismissible(
                    key: ValueKey(notification.id), // Unique key for each item
                    direction: DismissDirection.horizontal, // Allow sliding to the left
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) async {
                      await notificationController.clearMessage(notification.id!); // Remove the item
                      setState(() {
                        notifications.removeWhere((n) => n.id == notification.id); // Remove from the main list
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent[50],
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      child: ListTile(
                        title: Text(
                          "Message(${index + 1})",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          '${notification.message}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        leading: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.purple.withOpacity(0.5),
                              width: 2.0,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset('Assets/2PURPLE.png'),
                          ),
                        ),
                        trailing: const Icon(Icons.message_outlined),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
