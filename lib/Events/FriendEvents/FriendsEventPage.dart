
import 'package:flutter/material.dart';
import 'package:hedieaty/Controller/EventController.dart';
import 'package:hedieaty/Controller/GiftController.dart';
import 'package:hedieaty/Events/FriendEvents/FriendsEventDetailsPage.dart';
import 'package:hedieaty/Gifts/FriendGift/FriendGiftsPage.dart';
import 'package:hedieaty/Model/Event_Model.dart';
import 'package:intl/intl.dart';

class FriendsEventPage extends StatefulWidget {
  final int friendId;
  final String friendName;

  const FriendsEventPage({super.key, required this.friendId, required this.friendName});

  @override
  State<FriendsEventPage> createState() => _FriendsEventPageState();
}

class _FriendsEventPageState extends State<FriendsEventPage> {

  final EventController eventController = EventController();
  TextEditingController searchController = TextEditingController();
  final GiftController giftController = GiftController();
  DateFormat dateFormat = DateFormat("dd-MM-yyyy");
  List<Event> events = [];
  List<Event> filteredEvents = [];
  String sortBy = 'name';
  late String Name;
  late int FriendID;

  @override
  void initState() {
    super.initState();
    Name = widget.friendName;
    FriendID = widget.friendId;
    searchController.addListener(searchEvents);
    loadFriendEvents();
  }

  void loadFriendEvents() async {
    final fetchedEvents = await eventController.getFriendEvents(widget.friendId);
    setState(() {
      events = fetchedEvents.map((event) {
        // Parse the event's date
        DateTime eventDate = dateFormat.parse(event.date); // Assuming `event.date` is in "dd-MM-yyyy" format
        event.status = determineEventStatus(eventDate); // Update status dynamically
        return event;
      }).toList();
      filteredEvents = events; // Initially, all events are displayed
    });
    
    fetchEventGifts(filteredEvents);
  }

  void fetchEventGifts(List<Event> events) async{
    for (var event in events) {
      final gifts = await giftController.friendGiftsList(event.id!);

      setState(() {
        event.gifts = gifts!;
      });
    }
  }

  String determineEventStatus(DateTime eventDate) {
    final DateTime now = DateTime.now();
    if (eventDate.isAfter(now)) {
      return 'Upcoming';
    }
    else if (eventDate.year == now.year &&
        eventDate.month == now.month &&
        eventDate.day == now.day) {
      return 'Current';
    }
    else {
      return 'Past';
    }
  }

  void sortEvents(String sortBy) {
    setState(() {
      this.sortBy = sortBy;
      events.sort((a, b) {
        switch (sortBy) {
          case 'name':
            return a.name.compareTo(b.name);
          case 'category':
            return a.category.compareTo(b.category);
          case 'status':
            return statusPriority(a.status).compareTo(statusPriority(b.status));
          default:
            return 0;
        }
      });
    });
  }

  int statusPriority(String status) {
    switch (status) {
      case 'Upcoming':
        return 1;
      case 'Current':
        return 2;
      case 'Past':
        return 3;
      default:
        return 4;
    }
  }

  void searchEvents() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredEvents = events
          .where((event) => event.name.toLowerCase().contains(query))
          .toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${Name}\'s Events',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ), //Change Name to the name of the friend
        foregroundColor: Colors.white,
        backgroundColor: Colors.purpleAccent[700],
        actions: [
          PopupMenuButton<String>(
            onSelected: sortEvents,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'name', child: Text('Sort by Name')),
              const PopupMenuItem(value: 'category', child: Text('Sort by Category')),
              const PopupMenuItem(value: 'status', child: Text('Sort by Status')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search events by name',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: events.isEmpty?
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
                                  FriendGiftsPage(eventId: event.id!,eventName: event.name, friendId: FriendID, ),
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
              ),
            ),
          ],
        ),
      ),

    );
  }
}
