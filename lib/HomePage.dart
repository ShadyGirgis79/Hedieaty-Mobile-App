import 'package:flutter/material.dart';
import 'package:hedieaty/ProfilePage.dart';
import 'package:hedieaty/EventListPage.dart';
class Friend {
  String? name;
  String? profileURL;
  String? phoneNumber;
  int events = 0;

  Friend({required this.name, required this.profileURL,required this.phoneNumber , required this.events});

  void addEvent() {
    events += 1;
  }

  void removeEvent() {
    if (events > 0) {
      events -= 1;
    }
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Friend> friends = [
    Friend(name: "Mina Fadi", profileURL: 'https://via.placeholder.com/150', phoneNumber: "01272517828", events: 2),
    Friend(name: "Fady Fodz", profileURL: 'https://via.placeholder.com/150', phoneNumber: "01112583719", events: 0),
    Friend(name: "Mina Wes", profileURL: 'https://via.placeholder.com/150', phoneNumber: "01022345678", events: 1),
    Friend(name: "Shady Shark", profileURL: 'https://via.placeholder.com/150', phoneNumber: "01233456789", events: 5),
    Friend(name: "Matwa White", profileURL: 'https://via.placeholder.com/150', phoneNumber: "01198765432", events: 0),
    Friend(name: "Besbes Besa", profileURL: 'https://via.placeholder.com/150', phoneNumber: "01065432123", events: 0),
    Friend(name: "John Doe", profileURL: 'https://via.placeholder.com/150', phoneNumber: "01211223344", events: 2),
    Friend(name: "Jane Smith", profileURL: 'https://via.placeholder.com/150', phoneNumber: "01177665544", events: 0),
    Friend(name: "Alex Johnson", profileURL: 'https://via.placeholder.com/150', phoneNumber: "01012345670", events: 1),

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
    String phone="";
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
              TextField(
                decoration: InputDecoration(labelText: "Phone"),
                onChanged: (value) {
                  phone = value;
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (name.isNotEmpty) {
                  setState(() {
                    friends.add(Friend(name: name, profileURL: profileURL, phoneNumber: phone, events: 0));
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

  // Function to handle option selected from the 3-dot menu
  void _onMenuSelected(String value) {
    if (value == 'create_event_list') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const EventListPage()),

      //ScaffoldMessenger.of(context).showSnackBar(
        // SnackBar(content: Text('Create Your Own Event/List selected')),
      );
    }
    else if (value == 'Profile'){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hedieaty"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.purpleAccent,
        actions: [
          PopupMenuButton<String>(
            onSelected: _onMenuSelected,  // Handle the selection
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'create_event_list',
                  child: Text('Create Your Own Event/List'),
                ),
                PopupMenuItem(
                  value: 'Profile',
                  child: Text('Profile'),
                )
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
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



