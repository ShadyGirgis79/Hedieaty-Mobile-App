import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/Controller/Functions/ShowMessage.dart';
import 'package:hedieaty/Events/MyEvents/MyEventsPage.dart';
import 'package:hedieaty/Gifts/PledgedGift/PledgedGiftsPage.dart';
import 'package:hedieaty/Model/Database/SyncFirebaseAndLocalDB.dart';
import 'package:hedieaty/Profile/NotificationsPage.dart';
import 'package:image_picker/image_picker.dart';
import '../Controller/ProfileController.dart';
import '../Controller/Functions/Validation.dart';
import '../Controller/Services/Authentication.dart';
import '../Model/User_Model.dart' as LocalUser; // Your custom User model

class ProfilePage extends StatefulWidget {

  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String currentUserID = FirebaseAuth.instance.currentUser!.uid;
  final ProfileController profileController = ProfileController();
  File? imageFile;

  String username ='';
  String phoneNumber = '';
  String preference ='';
  String profileURL= '';
  String email = '';

  final AuthService authService = AuthService();

  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  Future<void> fetchUserData() async {
    try {
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
    }
    catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        profileURL = imageFile!.path;
      });
    }
    await profileController.storeProfileImage(profileURL, currentUserID.hashCode);
  }


  void editPersonalInfo() {
    final usernameController = TextEditingController(text: username);
    final phoneController = TextEditingController(text: phoneNumber);
    final preferenceController = TextEditingController(text: preference);

    String phoneError = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Personal Information"),
          content: SingleChildScrollView( // Make content scrollable
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: "Username"),
                  controller: usernameController,
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Phone",
                    errorText: phoneError.isEmpty ? null : phoneError,
                  ),
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(labelText: "Preference"),
                  controller: preferenceController,
                ),
              ],
            ),
          ),
          actions: [
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await profileController.storeProfileImage('', currentUserID.hashCode);
                    showMessage(context, 'Profile Image has been removed');
                    setState(() {
                      profileURL = '';
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("Remove Image"),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () async {
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
                            Navigator.of(context).pop();
                          } else {
                            showMessage(context, 'Please enter a valid phone number');
                          }
                        },
                        child: const Text("Save"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel"),
                      ),
                    ),
                  ],
                ),
              ],
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
      resizeToAvoidBottomInset: true, // Important to avoid overflow when keyboard shows
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: size.height, // Ensures it fills the screen height
            ),
            child: IntrinsicHeight( // Adapts to content height
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // Profile Image and Name
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.purple.withOpacity(0.5),
                          width: 5.0,
                        ),
                      ),
                      child: ClipOval(
                        child: profileURL != ''
                            ? Image.file(File(profileURL), height: 200, width: 200, fit: BoxFit.cover,
                        )
                            : const Icon(Icons.image, size: 200, color: Colors.grey,),
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
                    // Buttons to update profile
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
                    // Notification settings
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.notifications),
                      label: const Text("Notifications"),
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
                                  onPressed: () async {

                                    SyncFirebaseAndLocalDB syncController = SyncFirebaseAndLocalDB();
                                    await syncController.syncFirebaseToLocalDB();

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
                      onTap: () async {
                        await Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                PledgedGiftsPage(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(0.5, 0.0); // Slide in from the right
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;

                              var tween =
                              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
