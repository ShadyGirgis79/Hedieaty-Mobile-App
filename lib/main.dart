﻿import 'dart:ffi';
import 'package:flutter/material.dart';

void main() {
  runApp(const HedieatyApp());
}

class HedieatyApp extends StatelessWidget {
  const HedieatyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedieaty App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Friend> friends = [
    Friend(name: "Mina Fadi", profileURL: 'https://via.placeholder.com/150', events: 2),
    Friend(name: "Fady Fodz", profileURL: 'https://via.placeholder.com/150', events: 0),
    Friend(name: "Mina Wes", profileURL: 'https://via.placeholder.com/150', events: 1),
    Friend(name: "Shady Shark", profileURL: 'https://via.placeholder.com/150', events: 5),
    Friend(name: "Matwa White", profileURL: 'https://via.placeholder.com/150', events: 0),
    Friend(name: "Besbes Besa", profileURL: 'https://via.placeholder.com/150', events: 0),
  ];

  List<Friend> filteredFriends = [];  // To hold the search results
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredFriends = friends;  // Initially show all friends
    searchController.addListener(_filterFriends);  // Add listener to the search input
  }

  // Function to filter friends based on search input
  void _filterFriends() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredFriends = friends
          .where((friend) => friend.name!.toLowerCase().contains(query))
          .toList();
    });
  }

  // Function to add a friend manually
  void _addFriendManually() {
    String name = "";
    String profileURL = 'https://via.placeholder.com/150';  // Default profile image URL

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Friend"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Name"),
                onChanged: (value) {
                  name = value;
                },
              ),
              // You can add more fields like phone number here if necessary
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (name.isNotEmpty) {
                  setState(() {
                    friends.add(Friend(name: name, profileURL: profileURL, events: 0));
                    filteredFriends = friends;  // Update the filtered list
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // Method to handle creating a new event or gift list
  void _createEventOrList() {
    // Implementation of creating a new event or gift list can be added here.
    // For now, it just shows a simple dialog.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Create Event/List"),
          content: Text("You can create a new event or gift list here."),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hedieaty"),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _createEventOrList,  // Calls the method to create event/list
              child: const Text("Create Your Own Event/List"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,  // Attach the controller
              decoration: InputDecoration(
                labelText: "Search Friends",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: FriendsList(friends: filteredFriends),  // Show filtered friends
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFriendManually,  // Calls the method to add a friend
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FriendsList extends StatelessWidget {
  final List<Friend> friends;

  FriendsList({required this.friends});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: friends.length,  // Number of friends
      itemBuilder: (context, index) {
        final friend = friends[index];  // Get each friend
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(friend.profileURL!),  // Friend's profile picture
          ),
          title: Text(friend.name!),  // Friend's name
          subtitle: Text(friend.events > 0
              ? 'Upcoming Events: ${friend.events}'  // Show number of events
              : 'No Upcoming Events'),  // Show "No Upcoming Events" if 0
        );
      },
    );
  }
}

class Friend {
  String? name;
  String? profileURL;
  int events = 0;

  Friend({required this.name, required this.profileURL, required this.events});

  void addEvent() {
    events += 1;
  }

  void removeEvent() {
    if (events > 0) {
      events -= 1;
    }
  }
}
