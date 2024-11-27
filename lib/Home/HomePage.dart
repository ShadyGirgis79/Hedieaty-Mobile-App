import 'package:flutter/material.dart';
import 'package:hedieaty/Events/MyEventsListPage.dart';
import 'package:hedieaty/Other/ProfilePage.dart';
import 'package:hedieaty/Model/Event_Model.dart';
import 'package:hedieaty/Model/User_Model.dart';
import 'package:hedieaty/Model/Gift_Model.dart';
import 'package:hedieaty/Home/FriendsList.dart';

// class Friend {
//   String? name;
//   String? profileURL;
//   String? phoneNumber;
//   int events = 0;
//
//   Friend({required this.name, required this.profileURL,required this.phoneNumber , required this.events});
//
// }


//
// class FriendsList extends StatelessWidget {
//   final List<Friend> friends;
//
//   const FriendsList({super.key, required this.friends});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: friends.length,  // Number of friends
//       itemBuilder: (context, index) {
//         final friend = friends[index];  // Get each friend
//         return ListTile(
//           leading: CircleAvatar(
//             backgroundImage: NetworkImage(friend.profileURL!),  // Friend's profile picture
//           ),
//           title: Text(friend.name!),  // Friend's name
//           subtitle: Text(friend.events > 0
//               ? 'Upcoming Events: ${friend.events}'  // Show number of events
//               : 'No Upcoming Events'), // Show "No Upcoming Events" if 0
//           onTap: () {
//             // Navigate to EventListPage when tapping on the friend
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const EventListPage(),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<User> friends = [
    User(
      name: "Mina Fadi",
      password: "minapass123",
      profileURL: 'https://via.placeholder.com/150',
      phoneNumber: "01272517828",
      events: [
        Event(
          name: "Birthday Party",
          category: "Personal",
          status: "Upcoming",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Teddy Bear", category: "Toy", status: "Pledged", price: 100),
            Gift(name: "Phone", category: "Electronics", status: "Unpledged", price: 24000),
            Gift(name: "Watch", category: "Electronics", status: "Unpledged", price: 8500),
          ],
        ),
        Event(
          name: "Project Meeting",
          category: "Work",
          status: "Past",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Harry Potter", category: "Books", status: "Pledged", price: 70),
            Gift(name: "Bracelet", category: "Accessories", status: "Pledged", price: 350),
          ],
        ),
        Event(
          name: "Project Meeting",
          category: "Work",
          status: "Past",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Harry Potter", category: "Books", status: "Pledged", price: 70),
            Gift(name: "Bracelet", category: "Accessories", status: "Pledged", price: 350),
          ],
        ),
        Event(
          name: "Project Meeting",
          category: "Work",
          status: "Past",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Harry Potter", category: "Books", status: "Pledged", price: 70),
            Gift(name: "Bracelet", category: "Accessories", status: "Pledged", price: 350),
          ],
        ),
        Event(
          name: "Project Meeting",
          category: "Work",
          status: "Past",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Harry Potter", category: "Books", status: "Pledged", price: 70),
            Gift(name: "Bracelet", category: "Accessories", status: "Pledged", price: 350),
          ],
        ),
        Event(
          name: "Project Meeting",
          category: "Work",
          status: "Past",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Harry Potter", category: "Books", status: "Pledged", price: 70),
            Gift(name: "Bracelet", category: "Accessories", status: "Pledged", price: 350),
          ],
        ),
        Event(
          name: "Project Meeting",
          category: "Work",
          status: "Past",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Harry Potter", category: "Books", status: "Pledged", price: 70),
            Gift(name: "Bracelet", category: "Accessories", status: "Pledged", price: 350),
          ],
        ),

        Event(
          name: "Conference",
          category: "Professional",
          status: "Current",
          date: DateTime(2023, 12, 25),
        ),
      ],
    ),
    User(
      name: "Sarah Johnson",
      password: "sarahsecure456",
      profileURL: 'https://via.placeholder.com/150',
      phoneNumber: "0987654321",
      events: [
        Event(
          name: "Wedding",
          category: "Family",
          status: "Upcoming",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Necklace", category: "Jewelry", status: "Pledged", price: 5000),
            Gift(name: "Dinner Set", category: "Home", status: "Unpledged", price: 3000),
          ],
        ),
        Event(
          name: "Wedding",
          category: "Family",
          status: "Upcoming",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Necklace", category: "Jewelry", status: "Pledged", price: 5000),
            Gift(name: "Dinner Set", category: "Home", status: "Unpledged", price: 3000),
          ],
        ),
        Event(
          name: "Wedding",
          category: "Family",
          status: "Upcoming",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Necklace", category: "Jewelry", status: "Pledged", price: 5000),
            Gift(name: "Dinner Set", category: "Home", status: "Unpledged", price: 3000),
          ],
        ),
        Event(
          name: "Wedding",
          category: "Family",
          status: "Upcoming",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Necklace", category: "Jewelry", status: "Pledged", price: 5000),
            Gift(name: "Dinner Set", category: "Home", status: "Unpledged", price: 3000),
          ],
        ),
        Event(
          name: "Wedding",
          category: "Family",
          status: "Upcoming",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Necklace", category: "Jewelry", status: "Pledged", price: 5000),
            Gift(name: "Dinner Set", category: "Home", status: "Unpledged", price: 3000),
          ],
        ),
        Event(
          name: "Wedding",
          category: "Family",
          status: "Upcoming",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Necklace", category: "Jewelry", status: "Pledged", price: 5000),
            Gift(name: "Dinner Set", category: "Home", status: "Unpledged", price: 3000),
          ],
        ),
        Event(
          name: "Wedding",
          category: "Family",
          status: "Upcoming",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Necklace", category: "Jewelry", status: "Pledged", price: 5000),
            Gift(name: "Dinner Set", category: "Home", status: "Unpledged", price: 3000),
          ],
        ),
        Event(
          name: "Wedding",
          category: "Family",
          status: "Upcoming",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Necklace", category: "Jewelry", status: "Pledged", price: 5000),
            Gift(name: "Dinner Set", category: "Home", status: "Unpledged", price: 3000),
          ],
        ),
        Event(
          name: "Wedding",
          category: "Family",
          status: "Upcoming",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Necklace", category: "Jewelry", status: "Pledged", price: 5000),
            Gift(name: "Dinner Set", category: "Home", status: "Unpledged", price: 3000),
          ],
        ),
        Event(
          name: "Wedding",
          category: "Family",
          status: "Upcoming",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Necklace", category: "Jewelry", status: "Pledged", price: 5000),
            Gift(name: "Dinner Set", category: "Home", status: "Unpledged", price: 3000),
          ],
        ),
        Event(
          name: "Team Building Retreat",
          category: "Work",
          status: "Past",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Coffee Mug", category: "Accessories", status: "Pledged", price: 150),
          ],
        ),
      ],
    ),
    User(
      name: "John Smith",
      password: "johnsmith789",
      profileURL: 'https://via.placeholder.com/150',
      phoneNumber: "1234567890",
      events: [
        Event(
          name: "Charity Auction",
          category: "Community",
          status: "Current",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Painting", category: "Art", status: "Unpledged", price: 1200),
            Gift(name: "Handmade Bag", category: "Craft", status: "Pledged", price: 500),
          ],
        ),
        Event(
          name: "Startup Pitch",
          category: "Professional",
          status: "Upcoming",
          date: DateTime(2023, 12, 25),
        ),
      ],
    ),
    User(
      name: "Emily Davis",
      password: "emily123pass",
      profileURL: 'https://via.placeholder.com/150',
      phoneNumber: "9876543210",
      events: [
        Event(
          name: "Baby Shower",
          category: "Family",
          status: "Upcoming",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Baby Stroller", category: "Childcare", status: "Unpledged", price: 15000),
            Gift(name: "Diaper Bag", category: "Accessories", status: "Pledged", price: 2500),
          ],
        ),
        Event(
          name: "Book Club",
          category: "Hobby",
          status: "Past",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Novel", category: "Books", status: "Pledged", price: 300),
          ],
        ),
      ],
    ),
    User(
        name: "Matwa",
        password: "Matwa123",
        profileURL: 'https://via.placeholder.com/150',
        phoneNumber: "012363727"),
    User(
      name: "Besbes besa",
      password: "Besapass123",
      profileURL: 'https://via.placeholder.com/150',
      phoneNumber: "01272517828",
      events: [
        Event(
          name: "Birthday Party",
          category: "Personal",
          status: "Upcoming",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Teddy Bear", category: "Toy", status: "Pledged", price: 100),
            Gift(name: "Phone", category: "Electronics", status: "Unpledged", price: 24000),
            Gift(name: "Watch", category: "Electronics", status: "Unpledged", price: 8500),
          ],
        ),
        Event(
          name: "Project Meeting",
          category: "Work",
          status: "Past",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Harry Potter", category: "Books", status: "Pledged", price: 70),
            Gift(name: "Bracelet", category: "Accessories", status: "Pledged", price: 350),
          ],
        ),
        Event(
          name: "Conference",
          category: "Professional",
          status: "Current",
          date: DateTime(2023, 12, 25),
        ),
        Event(
          name: "Conference",
          category: "Professional",
          status: "Current",
          date: DateTime(2023, 12, 25),
        ),
        Event(
          name: "Conference",
          category: "Professional",
          status: "Current",
          date: DateTime(2023, 12, 25),
        ),
        Event(
          name: "Conference",
          category: "Professional",
          status: "Current",
          date: DateTime(2023, 12, 25),
        ),
        Event(
          name: "Conference",
          category: "Professional",
          status: "Current",
          date: DateTime(2023, 12, 25),
        ),
        Event(
          name: "Conference",
          category: "Professional",
          status: "Current",
          date: DateTime(2023, 12, 25),
        ),
      ],
    ),
    User(
      name: "Fady Fodz",
      password: "Fodz456",
      profileURL: 'https://via.placeholder.com/150',
      phoneNumber: "0987654321",
      events: [
        Event(
          name: "Wedding",
          category: "Family",
          status: "Upcoming",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Necklace", category: "Jewelry", status: "Pledged", price: 5000),
            Gift(name: "Dinner Set", category: "Home", status: "Unpledged", price: 3000),
          ],
        ),
        Event(
          name: "Team Building Retreat",
          category: "Work",
          status: "Past",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Coffee Mug", category: "Accessories", status: "Pledged", price: 150),
          ],
        ),
      ],
    ),
    User(
      name: "Wezaa Wes",
      password: "Wez789",
      profileURL: 'https://via.placeholder.com/150',
      phoneNumber: "1234567890",
      events: [
        Event(
          name: "Charity Auction",
          category: "Community",
          status: "Current",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Painting", category: "Art", status: "Unpledged", price: 1200),
            Gift(name: "Handmade Bag", category: "Craft", status: "Pledged", price: 500),
          ],
        ),
        Event(
          name: "Startup Pitch",
          category: "Professional",
          status: "Upcoming",
          date: DateTime(2023, 12, 25),
        ),
      ],
    ),
    User(
      name: "Mina Fadi",
      password: "minapass123",
      profileURL: 'https://via.placeholder.com/150',
      phoneNumber: "01272517828",
      events: [
        Event(
          name: "Birthday Party",
          category: "Personal",
          status: "Upcoming",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Teddy Bear", category: "Toy", status: "Pledged", price: 100),
            Gift(name: "Phone", category: "Electronics", status: "Unpledged", price: 24000),
            Gift(name: "Watch", category: "Electronics", status: "Unpledged", price: 8500),
          ],
        ),
        Event(
          name: "Project Meeting",
          category: "Work",
          status: "Past",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Harry Potter", category: "Books", status: "Pledged", price: 70),
            Gift(name: "Bracelet", category: "Accessories", status: "Pledged", price: 350),
          ],
        ),
        Event(
          name: "Conference",
          category: "Professional",
          status: "Current",
          date: DateTime(2023, 12, 25),
        ),
      ],
    ),
    User(
      name: "Sarah Johnson",
      password: "sarahsecure456",
      profileURL: 'https://via.placeholder.com/150',
      phoneNumber: "0987654321",
      events: [
        Event(
          name: "Wedding",
          category: "Family",
          status: "Upcoming",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Necklace", category: "Jewelry", status: "Pledged", price: 5000),
            Gift(name: "Dinner Set", category: "Home", status: "Unpledged", price: 3000),
          ],
        ),
        Event(
          name: "Team Building Retreat",
          category: "Work",
          status: "Past",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Coffee Mug", category: "Accessories", status: "Pledged", price: 150),
          ],
        ),
      ],
    ),
    User(
      name: "John Smith",
      password: "johnsmith789",
      profileURL: 'https://via.placeholder.com/150',
      phoneNumber: "1234567890",
      events: [
        Event(
          name: "Charity Auction",
          category: "Community",
          status: "Current",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Painting", category: "Art", status: "Unpledged", price: 1200),
            Gift(name: "Handmade Bag", category: "Craft", status: "Pledged", price: 500),
          ],
        ),
        Event(
          name: "Startup Pitch",
          category: "Professional",
          status: "Upcoming",
          date: DateTime(2023, 12, 25),
        ),
      ],
    ),
    User(
      name: "Emily Davis",
      password: "emily123pass",
      profileURL: 'https://via.placeholder.com/150',
      phoneNumber: "9876543210",
      events: [
        Event(
          name: "Baby Shower",
          category: "Family",
          status: "Upcoming",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Baby Stroller", category: "Childcare", status: "Unpledged", price: 15000),
            Gift(name: "Diaper Bag", category: "Accessories", status: "Pledged", price: 2500),
          ],
        ),
        Event(
          name: "Book Club",
          category: "Hobby",
          status: "Past",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Novel", category: "Books", status: "Pledged", price: 300),
          ],
        ),
      ],
    ),
    User(
        name: "Tony Bassem",
        password: "Matwa123",
        profileURL: 'https://via.placeholder.com/150',
        phoneNumber: "012363727"),
    User(
      name: "Basbosa",
      password: "Besapass123",
      profileURL: 'https://via.placeholder.com/150',
      phoneNumber: "01272517828",
      events: [
        Event(
          name: "Birthday Party",
          category: "Personal",
          status: "Upcoming",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Teddy Bear", category: "Toy", status: "Pledged", price: 100),
            Gift(name: "Phone", category: "Electronics", status: "Unpledged", price: 24000),
            Gift(name: "Watch", category: "Electronics", status: "Unpledged", price: 8500),
          ],
        ),
        Event(
          name: "Project Meeting",
          category: "Work",
          status: "Past",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Harry Potter", category: "Books", status: "Pledged", price: 70),
            Gift(name: "Bracelet", category: "Accessories", status: "Pledged", price: 350),
          ],
        ),
        Event(
          name: "Conference",
          category: "Professional",
          status: "Current",
          date: DateTime(2023, 12, 25),
        ),
        Event(
          name: "Conference",
          category: "Professional",
          status: "Current",
          date: DateTime(2023, 12, 25),
        ),
        Event(
          name: "Conference",
          category: "Professional",
          status: "Current",
          date: DateTime(2023, 12, 25),
        ),
        Event(
          name: "Conference",
          category: "Professional",
          status: "Current",
          date: DateTime(2023, 12, 25),
        ),
        Event(
          name: "Conference",
          category: "Professional",
          status: "Current",
          date: DateTime(2023, 12, 25),
        ),
        Event(
          name: "Conference",
          category: "Professional",
          status: "Current",
          date: DateTime(2023, 12, 25),
        ),
      ],
    ),
    User(
      name: "Mark el 3abd",
      password: "Fodz456",
      profileURL: 'https://via.placeholder.com/150',
      phoneNumber: "0987654321",
      events: [
        Event(
          name: "Wedding",
          category: "Family",
          status: "Upcoming",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Necklace", category: "Jewelry", status: "Pledged", price: 5000),
            Gift(name: "Dinner Set", category: "Home", status: "Unpledged", price: 3000),
          ],
        ),
        Event(
          name: "Team Building Retreat",
          category: "Work",
          status: "Past",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Coffee Mug", category: "Accessories", status: "Pledged", price: 150),
          ],
        ),
      ],
    ),
    User(
      name: "Wezaa 2",
      password: "Wez789",
      profileURL: 'https://via.placeholder.com/150',
      phoneNumber: "1234567890",
      events: [
        Event(
          name: "Charity Auction",
          category: "Community",
          status: "Current",
          date: DateTime(2023, 12, 25),
          gifts: [
            Gift(name: "Painting", category: "Art", status: "Unpledged", price: 1200),
            Gift(name: "Handmade Bag", category: "Craft", status: "Pledged", price: 500),
          ],
        ),
        Event(
          name: "Startup Pitch",
          category: "Professional",
          status: "Upcoming",
          date: DateTime(2023, 12, 25),
          gifts: [],
        ),
      ],
    ),
  ];

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

  // Function to add a friend manually
  void _addFriendManually() {
    String name = "";
    String phone="";
    String profileURL = 'https://via.placeholder.com/150';  // Default profile image URL
    String pass ="";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Friend"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Name"),
                onChanged: (value) {
                  name = value;
                },
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(labelText: "Phone"),
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
                    friends.add(User(name: name,password:pass  ,profileURL: profileURL, phoneNumber: phone));
                    filteredFriends = friends;  // Update the filtered list
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Add"),
            ),
            SizedBox(width: 10,),
            ElevatedButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: const Text("Back"),
            ),
          ],
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
        title: const Text("Hedieaty",
          style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),),
        foregroundColor: Colors.white,
        backgroundColor: Colors.purpleAccent,
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
        onPressed: _addFriendManually,  // Calls the method to add a friend
        child: const Icon(Icons.add),
      ),
    );
  }
}



