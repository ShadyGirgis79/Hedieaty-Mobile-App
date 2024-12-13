
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/Controller/EventController.dart';
import 'package:hedieaty/MyEvents/AddEventPage.dart';
import 'package:hedieaty/MyEvents/EventsList.dart';
import 'package:hedieaty/Model/Event_Model.dart';

class MyEventPage extends StatefulWidget {
  const MyEventPage({super.key});

  @override
  State<MyEventPage> createState() => _MyEventPageState();
}

class _MyEventPageState extends State<MyEventPage> {
  final String currentUserID = FirebaseAuth.instance.currentUser!.uid;
  final EventController eventController = EventController();
  List<Event> events=[];
  List<Event> filteredEvents = []; // List to hold the filtered events
  String sortBy = 'name';
  String searchQuery = ""; // To store the current search query

  @override
  void initState() {
    super.initState();
    loadFriends(); // Load events when the page is initialized
  }

  void loadFriends() async {
    final fetchedEvents = await eventController.eventsList();

    setState(() {
      events = fetchedEvents!;
      filteredEvents = fetchedEvents; // Initially, all events are displayed
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
      searchQuery = query.toLowerCase();
      filteredEvents = events.where((event) {
        return event.name.toLowerCase().contains(searchQuery) ||
            event.category.toLowerCase().contains(searchQuery);
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
                onChanged: searchEvents,
                decoration: InputDecoration(
                  hintText: 'Search events by name or category',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            Expanded( // Wrap the ListView.builder in Expanded
              child: EventsList(events: filteredEvents),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEventPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

