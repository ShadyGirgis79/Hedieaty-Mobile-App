import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hedieaty/Events/MyEventsListPage.dart';
import 'package:hedieaty/Registration/SignInPage.dart';
import 'package:hedieaty/Gifts/PledgedGifts.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  XFile? imageFile;
  final ImagePicker _picker = ImagePicker();
  String username = "Shady Shark";
  String profileURL = "Assets/MyPhoto.png";
  String phoneNumber = '01272517828';

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          imageFile = pickedFile;
        });
      }
    } catch (e) {
      // Handle errors, such as permission denial
      debugPrint('Error picking image: $e');
    }
  }

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
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(labelText: "Phone"),
                onChanged: (value) {
                  newPhoneNumber = value;
                },
                controller: TextEditingController(text: phoneNumber),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  username = newUsername;
                  phoneNumber = newPhoneNumber;
                });
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
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
        title: const Text(
          "My Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
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
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.purple.withOpacity(0.5),
                    width: 5.0,
                  ),
                ),
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.purpleAccent,
                  backgroundImage: imageFile != null
                      ? FileImage(File(imageFile!.path))
                      : AssetImage(profileURL) as ImageProvider,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                username,
                style: const TextStyle(
                  color: Colors.purple,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                phoneNumber,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.3),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),

              ElevatedButton.icon(
                onPressed: pickImage, // Call pickImage function
                icon: const Icon(Icons.camera_alt),
                label: const Text("Change Profile Image"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purpleAccent,
                ),
              ),
              const SizedBox(height: 10),

              // Buttons to update profile and notification settings
              ElevatedButton.icon(
                onPressed: editPersonalInfo,
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

              // List of user's created events
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyEventsList(),
                    ),
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

              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Are you sure you want to Sign Out?"),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => SignInPage()),
                                    (Route<dynamic> route) => false, // Remove all previous routes
                              );
                            },
                            child: const Text("Yes"),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purpleAccent,
                ),
              ),
              const SizedBox(height: 10),

              ListTile(
                leading: const Icon(Icons.card_giftcard),
                title: const Text('My Pledged Gifts'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PLedgedGiftsPage(),
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
}
