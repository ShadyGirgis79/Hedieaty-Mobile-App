import 'package:flutter/material.dart';
import 'package:hedieaty/FriendEvents/FriendsEventPage.dart';
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
            leading: CircleAvatar(
              backgroundImage: NetworkImage(friend.profileURL.isEmpty
                  ? 'https://via.placeholder.com/150'
                  : friend.profileURL),
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FriendsEventPage(friendId: friend.id as int, friendName: friend.name),
                ),
              );
            },
          ),
        );
      },
    );
  }
}