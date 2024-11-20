import 'package:flutter/material.dart';
import 'package:hedieaty/OldVersion/EventListPage.dart';
import 'package:hedieaty/Model/Friend_Model.dart';

class FriendsList extends StatelessWidget {
  final List<Friend> friends;

  const FriendsList({super.key, required this.friends});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ListView.builder(
          itemCount: friends.length,  // Number of friends
          itemBuilder: (context, index) {
            final friend = friends[index];  // Get each friend
            return Container(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(friend.profileURL!),  // Friend's profile picture
                ),
                title: Text(friend.name!),  // Friend's name
                subtitle: Text(friend.events > 0
                    ? 'Upcoming Events: ${friend.events}'  // Show number of events
                    : 'No Upcoming Events'), // Show "No Upcoming Events" if 0
                onTap: () {
                  // Navigate to EventListPage when tapping on the friend
                  Navigator.pushNamed(context, '/FriendsEvent');
                },
              ),
            );
          },
        )
    );
  }
}