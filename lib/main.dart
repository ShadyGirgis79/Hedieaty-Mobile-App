import 'package:flutter/material.dart';
import 'package:hedieaty/Other/SignInPage.dart';

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

      // Initial route
        // routes: {
        //   '/Home': (context) => const MyHomePage(),
        //   '/FriendsEvent': (context) => const FriendsEventList(),
        //   '/MyEvents': (context) => const MyEventsList(),
        //   '/FriendsGiftList': (context) => const FriendsGiftList(),
        //   '/MyGiftList': (context) => const MyGiftList(),
        //   '/FriendsGiftDetails': (context) => const FriendsGiftDetails(),
        //   '/MyGiftDetails': (context) => const MyGiftDetails(),
        //   '/Profile':(context) => const ProfilePage(),


    );
  }
}


