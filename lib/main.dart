import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/Model/Database/SyncFirebaseAndLocalDB.dart';
import 'Registration/SignInPage.dart';
import 'Registration/SignUpPage.dart';
import 'Home/HomePage.dart';
import 'Profile/ProfilePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SyncFirebaseAndLocalDB syncController = SyncFirebaseAndLocalDB();
  await syncController.syncFirebaseToLocalDB();

  runApp(HedieatyApp());
}

class HedieatyApp extends StatefulWidget {
  const HedieatyApp({super.key});

  @override
  State<HedieatyApp> createState() => _HedieatyAppState();

}

class _HedieatyAppState extends State<HedieatyApp> {

  @override
  void initState() {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('========================================= User is currently signed out! ====================================');
      }
      else {
        print('========================================== User is signed in! =============================================');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Hedieaty App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: FirebaseAuth.instance.currentUser == null
            ? SignInPage()
            : MyHomePage(),
        routes: {
          '/Home': (context) => const MyHomePage(),
          '/Profile': (context) => ProfilePage(),
          '/SignIn': (context) => const SignInPage(),
          '/SignUp': (context) => const SignUpPage(),
        }
    );
  }
}



