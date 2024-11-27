import 'package:flutter/material.dart';
import 'package:hedieaty/Events/FriendsEventListPage.dart';
import 'package:hedieaty/Model/User_Model.dart';

class FriendsList extends StatelessWidget {
  final List<User> friends;

  const FriendsList({super.key, required this.friends});


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ListView.builder(
          itemCount: friends.length,  // Number of friends
          itemBuilder: (context, index) {
            final friend = friends[index];  // Get each friend
            return Container(
              // decoration: BoxDecoration(
              //   border: Border.all(
              //     color: Colors.black,
              //     width: 2.0,
              //   ),
              //   borderRadius: BorderRadius.circular(8.0),
              // ),
              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(friend.profileURL!),  // Friend's profile picture
                ),
                title: Text(friend.name, // Friend's name
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),),
                subtitle: Text(friend.events
                    .where((event) => event.status != "Past")  // Don't count the past events
                    .length > 0
                    ? 'Upcoming Events: ${friend.events.where((event) => event.status != "Past").length}'  // Show number of events
                    : 'No Upcoming Events',
                  style: TextStyle(
                    //fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),), // Show "No Upcoming Events" if 0
                onTap: () {
                  // Navigate to EventListPage when tapping on the friend
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FriendsEventList(),
                    ),
                  );
                },
              ),
            );
          },
        )
    );
  }
}