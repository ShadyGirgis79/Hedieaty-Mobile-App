import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/Controller/ShowMessage.dart';
import 'package:hedieaty/Gifts/PledgedGifts.dart';
import 'package:hedieaty/MyEvents/MyEventsPage.dart';
import 'package:image_picker/image_picker.dart';
import '../Controller/ProfileController.dart';
import '../Controller/Validation.dart';
import '../Model/Database/Authentication.dart';
import '../Model/User_Model.dart' as LocalUser; // Your custom User model

class ProfilePage extends StatefulWidget {

  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String currentUserID = FirebaseAuth.instance.currentUser!.uid;
  XFile? imageFile;
  final ImagePicker _picker = ImagePicker();

  String username = '';
  String phoneNumber = '';
  String preference = '';
  String profileURL = '';
  String email = '';

  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final ProfileController profileController = ProfileController();
      final LocalUser.User? localUser = await profileController.fetchUserFromLocalDB();
      if (localUser != null) {
        setState(() {
          username = localUser.name;
          email = localUser.email;
          phoneNumber = localUser.phoneNumber;
          preference = localUser.preference;
          profileURL = localUser.profileURL;
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile =
      await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          imageFile = pickedFile;
        });

        await uploadProfileImage(pickedFile);
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Future<void> uploadProfileImage(XFile imageFile) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final ref = FirebaseStorage.instance
          .ref()
          .child("profilePictures/$uid.jpg");

      final uploadTask = ref.putFile(File(imageFile.path));
      final snapshot = await uploadTask;
      final downloadURL = await snapshot.ref.getDownloadURL();

      final DatabaseReference userRef =
      FirebaseDatabase.instance.ref("users/$uid");
      await userRef.update({'profileURL': downloadURL});

      setState(() {
        profileURL = downloadURL;
      });
    } catch (e) {
      debugPrint("Error uploading profile image: $e");
    }
  }

  void editPersonalInfo() {
    final usernameController = TextEditingController(text: username);
    final phoneController = TextEditingController(text: phoneNumber);
    final preferenceController = TextEditingController(text: preference);

    // Error message variable
    String phoneError = '';

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
                controller: usernameController,
              ),
              const SizedBox(height: 20),
              // Phone field with error message
              TextField(
                decoration: InputDecoration(
                  labelText: "Phone",
                  errorText: phoneError.isEmpty ? null : phoneError,
                ),
                controller: phoneController,
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(labelText: "Preference"),
                controller: preferenceController,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                // Validate phone number
                if (validatePhoneNumber(phoneController.text)) {
                  await ProfileController().updateUserData(
                    newName: usernameController.text,
                    newPhoneNumber: phoneController.text,
                    newPreference: preferenceController.text,
                  );
                  setState(() {
                    username = usernameController.text;
                    phoneNumber = phoneController.text;
                    preference = preferenceController.text;
                  });
                  // Close dialog
                  Navigator.of(context).pop();
                }
                else {
                  // Set error message if phone number is invalid
                  showMessage(context, 'Please enter a valid phone number');
                }
              },
              child: const Text("Save"),
            ),
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
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.purpleAccent[700],
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
                  backgroundColor: Colors.purpleAccent[700],
                  backgroundImage: imageFile != null
                      ? FileImage(File(imageFile!.path))
                      : null,
                  //AssetImage(profileURL) as ImageProvider,
                ),
              ),

              const SizedBox(height: 10),
              Text(
                username,
                style: TextStyle(
                  color: Colors.purpleAccent[700],
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),

              Text(
                email,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.3),
                  fontSize: 15,
                ),
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
                  backgroundColor: Colors.purpleAccent[700],
                ),
              ),
              const SizedBox(height: 10),

              // Buttons to update profile a
              ElevatedButton.icon(
                onPressed: editPersonalInfo,
                icon: const Icon(Icons.person),
                label: const Text("Update Personal Information"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purpleAccent[700],
                ),
              ),
              const SizedBox(height: 10),

              //Notification settings
              ElevatedButton.icon(
                onPressed: () {
                  // Action to update notification settings
                },
                icon: const Icon(Icons.notifications),
                label: const Text("Notification Settings"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purpleAccent[700],
                ),
              ),
              const SizedBox(height: 10),

              // List of user's created events
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyEventPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.event_available_rounded),
                label: const Text('My Created Events'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purpleAccent[700],
                ),
              ),
              const SizedBox(height: 40),

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
                              authService.signOut();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/SignIn',
                                    (Route<dynamic> route) => false, // Clears the navigation stack
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
                  backgroundColor: Colors.red[700],
                ),
              ),
              const SizedBox(height: 60),

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
