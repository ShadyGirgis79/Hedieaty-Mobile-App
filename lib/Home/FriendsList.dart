
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hedieaty/Events/FriendEvents/FriendsEventPage.dart';
import 'package:hedieaty/Model/User_Model.dart';

class FriendsList extends StatelessWidget {
  final List<User> friends;

  const FriendsList({super.key, required this.friends});

  @override
  Widget build(BuildContext context) {
    return friends.isEmpty
        ? Center(
      child: Text(
        'No friends yet. Add some!',
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
      ),
    )
        : ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: ListTile(
            leading: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.purple.withOpacity(0.5),
                  width: 2.0,
                ),
              ),
              child: ClipOval(
                child: friend.profileURL != ''
                    ? Image.file(File(friend.profileURL), height: 50, width: 50, fit: BoxFit.cover,)
                    : Image.asset('Assets/FriendImage.jpg'),
              ),
            ),
            title: Text(
              friend.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text(
              friend.events
                  .where((event) => event.status != "Past")
                  .isNotEmpty
                  ? 'Upcoming Events: ${friend.events.where((event) => event.status != "Past").length}'
                  : 'No Upcoming Events',
              style: const TextStyle(fontSize: 14),
            ),
            onTap: () async {
              await Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      FriendsEventPage(friendId: friend.id! , friendName: friend.name),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(0.5, 0.0); // Slide in from the right
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    var tween =
                    Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
