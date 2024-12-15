
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hedieaty/Controller/AddFriendController.dart';
import 'package:hedieaty/Controller/Functions/ShowMessage.dart';
import '../Controller/Functions/Validation.dart';
import '../Model/User_Model.dart';

class AddFriendPage extends StatefulWidget {
  final List<User> friends; // Existing friends list
  final User currentUser; // Current logged-in user

  const AddFriendPage(
      {super.key, required this.friends, required this.currentUser});

  @override
  State<AddFriendPage> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriendPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final AddFriendController addFriendController = AddFriendController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Friend"),
        backgroundColor: Colors.purpleAccent[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            //This button is for getting friends by contact
              onPressed: (){

              }, 
              icon: Icon(Icons.contact_phone_outlined)
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 50),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.phone),
                    errorText: phoneController.text.isNotEmpty &&
                        !validatePhoneNumber(phoneController.text)
                        ? "Invalid Egyptian phone number"
                        : null,
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    setState(() {});
                  },
                ),

                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    String result = await addFriendController.addFriendLocalDB(
                        nameController.text,
                        phoneController.text,
                        );

                    // String resultFirebase = await addFriendController.addFriendFirebase(
                    //   nameController.text,
                    //   phoneController.text,
                    // );


                    showMessage(context, result);

                    // Navigate back to the previous screen on success
                    if (result == "Friend added successfully!") {
                      Navigator.pop(context, true);
                    }
                  },
                  child: const Text("Add Friend"),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}