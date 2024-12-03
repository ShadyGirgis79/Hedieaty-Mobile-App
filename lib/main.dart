import 'package:flutter/material.dart';
import 'package:hedieaty/Registration/SignInPage.dart';

import 'Details/FriendsGiftDetailsPage.dart';
import 'Details/MyGiftDetailsPage.dart';
import 'Events/FriendsEventListPage.dart';
import 'Events/MyEventsListPage.dart';
import 'Gifts/FriendsGiftListPage.dart';
import 'Gifts/MyGiftListPage.dart';
import 'Home/HomePage.dart';
import 'Profile/ProfilePage.dart';

void main() {
  runApp(const MaterialApp(
    home: HedieatyApp(),
  ));
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
        home: SignInPage(),
        routes: {
          '/Home': (context) => const MyHomePage(),
          '/FriendsEvent': (context) => const FriendsEventList(),
          '/MyEvents': (context) => const MyEventsList(),
          '/FriendsGiftList': (context) => const FriendsGiftList(),
          '/MyGiftList': (context) => const MyGiftList(),
          '/FriendsGiftDetails': (context) => const FriendsGiftDetails(),
          '/MyGiftDetails': (context) => const MyGiftDetails(),
          '/Profile': (context) => const ProfilePage(),

        }
    );
  }
}


