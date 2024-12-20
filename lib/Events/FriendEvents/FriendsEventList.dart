
import 'package:flutter/material.dart';
import 'package:hedieaty/Events/FriendEvents/FriendsEventDetailsPage.dart';
import 'package:hedieaty/Gifts/FriendGift/FriendGiftsPage.dart';
import 'package:hedieaty/Model/Event_Model.dart';

class FriendsEventList extends StatelessWidget {
  final List<Event> events;
  const FriendsEventList({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return events.isEmpty?
    Center(
      child: Text(
        'No Events yet. Add some!',
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
      ),
    )
        :
    ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Container(
          decoration: BoxDecoration(
            color: event.status == "Past" ? Color(0xFF9393FF) : Color(0xABABFFFF),
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: ListTile(
            title: Text('${event.name}' ,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text('${event.category} • ${event.status}',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            leading: IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FriendsEventDetailsPage(event: event),
                  ),
                );
              },
              icon: const Icon(Icons.event),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.purpleAccent[700],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text('${event.gifts.length}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onTap: () async {
              if(event.status != "Past"){
                await Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        FriendGiftsPage(eventId: event.id!,eventName: event.name,),
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

              }
            },
          ),
        );
      },
    );
  }
}
