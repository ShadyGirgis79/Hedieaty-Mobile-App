
import 'package:flutter/material.dart';
import 'package:hedieaty/Model/Friend_Model.dart';

class FriendsListView extends StatelessWidget {
  final List<Friend> friends;
  final Function onFriendSelected;

  FriendsListView({required this.friends, required this.onFriendSelected});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(friend.profileURL!),
          ),
          title: Text(friend.name!),
          subtitle: Text(friend.events > 0 ? 'Upcoming Events: ${friend.events}' : 'No Upcoming Events'),
          onTap: () => onFriendSelected(friend),
        );
      },
    );
  }
}
