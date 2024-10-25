import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
              // Profile Image and Name
              Container(
                width: 150,
                child: const CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.purpleAccent,
                  backgroundImage: ExactAssetImage("assetName"), // Replace with your image path
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.purple.withOpacity(.5),
                    width: 5.0,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Shady Shark',
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Buttons to update profile and notification settings
              ElevatedButton.icon(
                onPressed: () {
                  // Action to update personal information
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
              const SizedBox(height: 20),
              // List of user's created events
              const Text(
                'My Created Events',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              // Mock list of events and gifts
              _buildEventList(),
              const SizedBox(height: 20),
              // Link to My Pledged Gifts Page
              ListTile(
                leading: const Icon(Icons.card_giftcard),
                title: const Text('My Pledged Gifts'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to My Pledged Gifts page
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
