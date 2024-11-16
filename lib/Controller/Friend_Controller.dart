
import 'package:flutter/material.dart';
import 'package:hedieaty/Model/Friend_Model.dart';

class FriendsListController extends ChangeNotifier {
  final List<Friend> friends;
  List<Friend> filteredFriends;

  FriendsListController({required this.friends}) : filteredFriends = friends;

  // Function to filter friends based on search input
  void filterFriends(String query) {
    filteredFriends = friends
        .where((friend) => friend.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Function to add a new friend
  void addFriend(String name, String phone) {
    friends.add(Friend(name: name, profileURL: 'https://via.placeholder.com/150', phoneNumber: phone, events: 0));
    filteredFriends = friends; // Update filtered list
  }
}
