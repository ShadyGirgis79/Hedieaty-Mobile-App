import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hedieaty/EventListPage.dart';
import 'package:hedieaty/MyPledgedGiftsPage.dart';
//import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  // XFile? imageFile;
  // final ImagePicker _picker = ImagePicker();
  String username = "Shady Shark";
  String profileURL = "Assets/MyPhoto.png";
  String phoneNumber = '01272517828';

  // Future<void> pickImage() async {
  //   final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       imageFile = XFile(pickedFile.path);
  //     });
  //   }
  //}

  void editPersonalInfo() {
    String newUsername = username;
    String newPhoneNumber = phoneNumber;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Personal Information"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Username"),
                onChanged: (value) {
                  newUsername = value;
                },
                controller: TextEditingController(text: username),
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Phone"),
                onChanged: (value) {
                  newPhoneNumber = value;
                },
                controller: TextEditingController(text: phoneNumber),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed:(){
                  //pickImage
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text("Change Profile Image"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  username = newUsername;
                  phoneNumber = newPhoneNumber;
                });
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.purpleAccent,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Profile Image and Name
              Container(
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.purple.withOpacity(.5),
                    width: 5.0,
                  )
                ),
                child: CircleAvatar(
                  radius: 80,
                  //backgroundColor: Colors.purpleAccent,
                 // backgroundImage: imageFile != null ? FileImage(imageFile! as File) as ImageProvider
                  //    : AssetImage(profileURL), // Replace with your image path
                ),
              ),
              const SizedBox(height: 10),
              Text(username,
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              Text(phoneNumber,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.3),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 20),
              // Buttons to update profile and notification settings
              ElevatedButton.icon(
                onPressed: () {
                  editPersonalInfo();
                },
                icon: const Icon(Icons.person),
                label: const Text("Update Personal Information"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purpleAccent,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Action to update notification settings
                },
                icon: const Icon(Icons.notifications),
                label: const Text("Notification Settings"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purpleAccent,
                ),
              ),
              const SizedBox(height: 10),

              //List of user's created events
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const EventListPage()),
                  );
                },
                icon: const Icon(Icons.event_available_rounded),
                label: const Text('My Created Events'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purpleAccent,
                ),
              ),
              const SizedBox(height: 10),

              // const Text(
              //   'My Created Events',
              //   style: TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.purple,
              //   ),
              // ),


              // Mock list of events and gifts
              //_buildEventList(),

              const SizedBox(height: 20),

              ListTile(
                leading: const Icon(Icons.card_giftcard),
                title: const Text('My Pledged Gifts'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyPledgedGiftsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

      ),
    );
  }

  // Mock event list builder
  Widget _buildEventList() {
    // You can replace this list with your dynamic event data
    List<Map<String, String>> events = [
      {"event": "Birthday Party", "gifts": "5 Gifts"},
      {"event": "Wedding", "gifts": "3 Gifts"},
      {"event": "Christmas", "gifts": "10 Gifts"},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(events[index]['event']!),
            subtitle: Text("Associated Gifts: ${events[index]['gifts']}"),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Edit event action
              },
            ),
          ),
        );
      },
    );
  }
}
