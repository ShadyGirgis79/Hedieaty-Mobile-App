import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hedieaty/Home/HomePage.dart';
import 'package:hedieaty/Model/Database/Database.dart';
import 'package:hedieaty/Model/Database/SyncFirebaseAndLocalDB.dart';
import 'package:hedieaty/Registration/SignInPage.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hedieaty/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();



  group('Test App to pledge gift', () {
    testWidgets(
        'Testing App to Sign in and open friends gifts and pledge one of the gifts',
            (WidgetTester tester) async {
          // Start the app
          await Firebase.initializeApp();
          HedieatyDatabase db = HedieatyDatabase();
          SyncFirebaseAndLocalDB syncController = SyncFirebaseAndLocalDB();
          await syncController.syncFirebaseToLocalDB();

          //Run App
          runApp(MaterialApp(
            home: SignInPage(),
          ));

          await tester.pumpAndSettle();
          await Future.delayed(Duration(seconds: 5));

          // Find the email and password text fields and the sign in button
          final emailField = find.byKey(const Key('emailTextField'));
          final passwordField = find.byKey(const Key('passwordTextField'));
          final signInButton = find.byKey(const Key('signInButton'));

          // Enter email and password
          await tester.enterText(emailField, 'shady@email.com');
          await tester.enterText(passwordField, 'shady123');

          // Tap the "Sign In" button
          await Future.delayed(Duration(seconds: 5));
          await tester.ensureVisible(signInButton);
          await Future.delayed(Duration(seconds: 5));
          await tester.tap(signInButton);
          await tester.pumpAndSettle(Duration(seconds: 5)); // Wait for navigation to complete

          // Verify we're on the home page
          expect(find.byType(MyHomePage), findsOneWidget);

          // Ensure Friend exists before trying to tap
          final friendButton = find.text("tina");
          expect(friendButton, findsOneWidget);
          await Future.delayed(Duration(seconds: 5));
          await tester.tap(friendButton);
          await tester.pumpAndSettle(Duration(seconds: 5));

          // Ensure Event exists before trying to tap
          final eventButton = find.text("party");
          expect(eventButton , findsOneWidget);
          await Future.delayed(Duration(seconds: 5));
          await tester.tap(eventButton);
          await tester.pumpAndSettle(Duration(seconds: 5));

          // Ensure Gift exists before trying to tap
          final giftButton = find.text("tshirt");
          expect(giftButton , findsOneWidget);
          await Future.delayed(Duration(seconds: 5));
          await tester.tap(giftButton);
          await tester.pumpAndSettle(Duration(seconds: 10));

          // Ensure the pledgeButton is visible before tapping
          final pledgeButton = find.byKey(const Key('pledgeButton'));
          await Future.delayed(Duration(seconds: 5));

          // Scroll until the pledgeButton is visible
          await tester.ensureVisible(pledgeButton);
          await tester.pumpAndSettle(); // Allow animations or scrolls to complete

          // Verify the button exists
          expect(pledgeButton, findsOneWidget);

          // Tap the pledgeButton
          await Future.delayed(Duration(seconds: 5));
          await tester.tap(pledgeButton);
          await tester.pumpAndSettle(Duration(seconds: 10)); // Allow the tap action to complete

          // Success
          print('Test passed successfully!');

        });
  });
}
