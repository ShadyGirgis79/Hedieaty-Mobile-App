
import 'package:flutter/material.dart';
import 'package:hedieaty/Model/Friend_Model.dart';
import 'package:hedieaty/Controller/Friend_Controller.dart';
import 'package:hedieaty/View/Home_View.dart';
import 'package:hedieaty/View/Friends_View.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FriendsListController controller;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = FriendsListController(friends: [
      Friend(name: "Mina Fadi", profileURL: 'https://via.placeholder.com/150', phoneNumber: "01272517828", events: 2),
      Friend(name: "Fady Fodz", profileURL: 'https://via.placeholder.com/150', phoneNumber: "01112583719", events: 0),
      Friend(name: "Mina Wes", profileURL: 'https://via.placeholder.com/150', phoneNumber: "01022345678", events: 1),
      Friend(name: "Shady Shark", profileURL: 'https://via.placeholder.com/150', phoneNumber: "01233456789", events: 5),
      Friend(name: "Matwa White", profileURL: 'https://via.placeholder.com/150', phoneNumber: "01198765432", events: 0),
      Friend(name: "Besbes Besa", profileURL: 'https://via.placeholder.com/150', phoneNumber: "01065432123", events: 0),
      Friend(name: "John Doe", profileURL: 'https://via.placeholder.com/150', phoneNumber: "01211223344", events: 2),
      Friend(name: "Jane Smith", profileURL: 'https://via.placeholder.com/150', phoneNumber: "01177665544", events: 0),
      Friend(name: "Alex Johnson", profileURL: 'https://via.placeholder.com/150', phoneNumber: "01012345670", events: 1),
    ]);

    searchController.addListener(() {
      setState(() {
        controller.filterFriends(searchController.text);
      });
    });
  }

  void _addFriendManually() {
    String name = "";
    String phone = "";

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
              SizedBox(height: 10),
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
                    controller.addFriend(name, phone);
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

  void _onMenuSelected(String value) {
    if (value == 'create_event_list') {
      // Navigate to create event list page
    } else if (value == 'Profile') {
      // Navigate to Profile page
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyHomePageView(
      searchController: searchController,
      onSearchTextChanged: (query) {
        setState(() {
          controller.filterFriends(query);
        });
      },
      onAddFriendPressed: _addFriendManually,
      filteredFriends: controller.filteredFriends,
      onMenuSelected: _onMenuSelected,
    );
  }
}
