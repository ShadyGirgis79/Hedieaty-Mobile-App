import 'package:flutter/material.dart';
import 'package:hedieaty/Events/MyEventsListPage.dart';
import 'package:hedieaty/Home/AddFriend.dart';
import 'package:hedieaty/Profile/ProfilePage.dart';
import 'package:hedieaty/Model/User_Model.dart';
import 'package:hedieaty/Home/FriendsList.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<User> friends=[];

  List<User> filteredFriends = [];  // To hold the search results
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
          .where((friend) => friend.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void addOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Friends"),
          content: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddFriend(), // Replace with your target page widget
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text("Manually"),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {

                    Navigator.of(context).pop();
                  },
                  child: const Text("Contacts"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to handle option selected from the 3-dot menu
  void _onMenuSelected(String value) {
    if (value == 'create_event_list') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyEventsList(),
        ),
      );
    }
    else if (value == 'Profile'){
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
        title: const Text("Home Page",
          style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),),
        foregroundColor: Colors.white,
        backgroundColor: Colors.purpleAccent[700],
        actions: [
          PopupMenuButton<String>(
            onSelected: _onMenuSelected,  // Handle the selection
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
                  controller: searchController,  // Attach the controller
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
                child: FriendsList(friends: filteredFriends), // Show filtered friends
              ),
            ],
          ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: ()=> {
          addOptions(),
        },  // Calls the method to add a friend
        child: const Icon(Icons.add),
      ),
    );
  }
}



