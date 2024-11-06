import 'package:flutter/material.dart';
import 'package:hedieaty/HomePage.dart';
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
      home: const MyHomePage(),

    );
  }
}

