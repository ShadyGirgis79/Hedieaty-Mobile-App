import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/Controller/EventController.dart';
import 'package:hedieaty/Events/MyEvents/AddEventPage.dart';
import 'package:hedieaty/Events/MyEvents/EventsList.dart';
import 'package:hedieaty/Model/Event_Model.dart';

class MyEventPage extends StatefulWidget {
  const MyEventPage({super.key});

  @override
  State<MyEventPage> createState() => _MyEventPageState();
}

class _MyEventPageState extends State<MyEventPage> {
  final String currentUserID = FirebaseAuth.instance.currentUser!.uid;
  final EventController eventController = EventController();
  TextEditingController searchController = TextEditingController();
  List<Event> events = [];
  List<Event> filteredEvents = [];
  String sortBy = 'name';

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      searchEvents(searchController.text);
    });
    loadFriends(); // Load events when the page is initialized
  }

  Future<void> loadFriends() async {
    final fetchedEvents = await eventController.eventsList();
    setState(() {
      events = fetchedEvents ?? [];
      filteredEvents = fetchedEvents ?? []; // Initially, all events are displayed
    });
  }

  void sortEvents(String sortBy) {
    setState(() {
      this.sortBy = sortBy;
      filteredEvents.sort((a, b) {
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

  void searchEvents(String query) {
    setState(() {
      filteredEvents = events.where((event) {
        return event.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Events List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
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
              child: EventsList(events: filteredEvents),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to AddEventPage and wait for a result
          final bool? isEventAdded = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEventPage(),
            ),
          );
          // If a new event was added, refresh the list
          if (isEventAdded == true) {
            loadFriends(); // Reload the events list
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
