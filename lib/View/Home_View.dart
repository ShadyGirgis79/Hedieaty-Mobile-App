
// views/my_home_page_view.dart
import 'package:flutter/material.dart';
import 'package:hedieaty/Model/Friend_Model.dart';
import 'Friends_View.dart';

class MyHomePageView extends StatelessWidget {
  final TextEditingController searchController;
  final Function onSearchTextChanged;
  final Function onAddFriendPressed;
  final List<Friend> filteredFriends;
  final Function onMenuSelected;

  MyHomePageView({
    required this.searchController,
    required this.onSearchTextChanged,
    required this.onAddFriendPressed,
    required this.filteredFriends,
    required this.onMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hedieaty"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.purpleAccent,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => onMenuSelected(value),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(value: 'create_event_list', child: Text('Create Your Own Event/List')),
                PopupMenuItem(value: 'Profile', child: Text('Profile')),
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
              controller: searchController,
              onChanged: (value) => onSearchTextChanged(value),
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
            child: FriendsListView(friends: filteredFriends, onFriendSelected: (friend) {
              // Handle friend selection
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onAddFriendPressed(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
