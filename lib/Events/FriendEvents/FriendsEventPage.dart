
import 'package:flutter/material.dart';
import 'package:hedieaty/Controller/EventController.dart';
import 'package:hedieaty/Controller/GiftController.dart';
import 'package:hedieaty/Events/FriendEvents/FriendsEventList.dart';
import 'package:hedieaty/Model/Event_Model.dart';

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
  List<Event> events = [];
  List<Event> filteredEvents = [];
  String sortBy = 'name';
  late String Name;

  @override
  void initState() {
    super.initState();
    Name = widget.friendName;
    searchController.addListener(searchEvents);
    loadFriendEvents();
  }

  void loadFriendEvents() async {
    final fetchedEvents = await eventController.getFriendEvents(widget.friendId);
    setState(() {
      events = fetchedEvents;
      filteredEvents = fetchedEvents;
    });
    
    fetchEventGifts(filteredEvents);
  }

  void fetchEventGifts(List<Event> events) async{
    for (var event in events) {
      final gifts = await giftController.giftsList(event.id!);

      setState(() {
        event.gifts = gifts!;
      });
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
              child: FriendsEventList(events: filteredEvents),
            ),
          ],
        ),
      ),

    );
  }
}
