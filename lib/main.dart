import 'package:flutter/material.dart';
import 'package:hedieaty/Events/FriendsEventListPage.dart';
import 'package:hedieaty/Gifts/FriendsGiftListPage.dart';
import 'package:hedieaty/Home/HomePage.dart';
import 'package:hedieaty/Events/MyEventsListPage.dart';
import 'package:hedieaty/Gifts/MyGiftListPage.dart';
import 'package:hedieaty/MyGiftDetailsPage.dart';

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
        initialRoute: '/Home', // Initial route
        routes: {
          '/Home': (context) => const MyHomePage(),
          '/FriendsEvent': (context) => const FriendsEventList(),
          '/MyEvents': (context) => const MyEventsList(),
          '/FriendsGiftList': (context) => const FriendsGiftList(),
          '/MyGiftList': (context) => const MyGiftList(),

          '/MyGiftDetails': (context) => const MyGiftDetails(),
        }
    );
  }
}
