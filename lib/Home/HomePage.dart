import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/Controller/EventController.dart';
import 'package:hedieaty/Controller/HomeController.dart';
import 'package:hedieaty/Events/MyEvents/MyEventsPage.dart';
import 'package:hedieaty/Home/AddFriendPage.dart';
import 'package:hedieaty/Profile/ProfilePage.dart';
import 'package:hedieaty/Model/User_Model.dart' as LocalUser;
import 'package:hedieaty/Home/FriendsList.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<LocalUser.User> friends = [];
  List<LocalUser.User> filteredFriends = []; // To hold the search results
  TextEditingController searchController = TextEditingController();
  final EventController eventController = EventController();
  final currentUser = FirebaseAuth.instance.currentUser;
  final currentUserID = FirebaseAuth.instance.currentUser?.uid.hashCode;
  final HomeController homeController = HomeController();


  @override
  void initState() {
    super.initState();
    searchController.addListener(searchFriends);
    loadFriends(currentUserID); // Load friends when the page is initialized
  }

  void loadFriends(currentUserID) async {
    final fetchedFriends = await homeController.friendsList(currentUserID);

    setState(() {
      friends = fetchedFriends!;
      filteredFriends = fetchedFriends; // Initialize with all friends
    });

    fetchFriendsEvents(filteredFriends);
  }

  void fetchFriendsEvents(List<LocalUser.User> friends) async {
    for (var friend in friends) {
      final events = await eventController.getFriendEvents(friend.id!);

      setState(() {
        friend.events = events;
      });
    }
  }

  void searchFriends() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredFriends = friends
          .where((friend) => friend.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void onMenuSelected(String value) {
    if (value == 'create_event_list') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyEventPage(),
        ),
      );
    } else if (value == 'Profile') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home Page",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.purpleAccent[700],
        actions: [
          PopupMenuButton<String>(
            onSelected: onMenuSelected,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'create_event_list',
                  child: Text('Create Your Own Event/List'),
                ),
                const PopupMenuItem(
                  value: 'Profile',
                  child: Text('Profile'),
                )
              ];
            },
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
                  labelText: "Search Friends",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FriendsList(friends: filteredFriends),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        //Adding Friends manually
        onPressed: () async {
          final LocalUser.User? currentUser = await homeController.fetchUserFromLocalDB();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddFriendPage(
                friends: friends,
                currentUser: currentUser!,
              ),
            ),
          ).then((value) {
            if (value == true) {
              loadFriends(currentUserID); // Reload the friends list after a successful addition
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
