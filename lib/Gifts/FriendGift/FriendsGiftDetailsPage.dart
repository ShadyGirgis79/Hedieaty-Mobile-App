
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/Controller/Functions/ShowMessage.dart';
import 'package:hedieaty/Controller/GiftController.dart';
import 'package:hedieaty/Controller/Services/Internet.dart';
import 'package:hedieaty/Model/Gift_Model.dart';
import 'dart:io';

class FriendsGiftDetails extends StatefulWidget {
  final Gift gift;
  const FriendsGiftDetails({super.key, required this.gift});

  @override
  State<FriendsGiftDetails> createState() => _FriendsGiftDetailsState();
}

class _FriendsGiftDetailsState extends State<FriendsGiftDetails> {
  final int currentUserID = FirebaseAuth.instance.currentUser!.uid.hashCode;
  final GiftController giftController = GiftController();
  final Internet internet = Internet();

  bool isPledged = false;
  bool showButton = false;
  late String Name;
  late String Category;
  late String Status;
  late String Description;
  late String ImageURL;
  late double Price;
  late int giftId;

  @override
  void initState() {
    super.initState();
    Name = widget.gift.name;
    Category = widget.gift.category;
    Status = widget.gift.status;
    Description = widget.gift.description;
    ImageURL = widget.gift.imageURL;
    Price = widget.gift.price;
    giftId = widget.gift.id!;
    isPledged = Status == "Pledged";

    checkButtonVisibility();
  }

  Future<void> checkButtonVisibility() async {
    if (isPledged) {
      // If the gift is pledged, check if the current user is the pledger
      bool isPledgingUser = await giftController.checkPledgedUser(giftId, currentUserID);
      setState(() {
        showButton = isPledgingUser; // Show the button only if the current user pledged the gift
      });
    }
    else {
      // If the gift is not pledged, show the button
      setState(() {
        showButton = true;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${Name} Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),),
        backgroundColor: Colors.purpleAccent[700],
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image preview with border and upload button
                  Center(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isPledged ? Colors.red : Colors.green,
                              width: 12.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ImageURL != ""
                              ? Image.file(File(ImageURL), height: 200, width: 200, fit: BoxFit.cover)
                              : const Icon(Icons.image, size: 200, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  //Container for the Gift Name
                  Container(
                    decoration:BoxDecoration(
                      //color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                      //borderRadius: BorderRadius.circular(8.0),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child:ListTile(
                      title: const Text("Name",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text("${Name}" ,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  //Container for the Description
                  Container(
                    decoration:BoxDecoration(
                      //color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                      //borderRadius: BorderRadius.circular(8.0),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child:ListTile(
                      title: const Text("Description",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text("${Description}" ,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  //Container for the Category
                  Container(
                    decoration:BoxDecoration(
                      //color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                      //borderRadius: BorderRadius.circular(8.0),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child:ListTile(
                      title: const Text("Category",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text("${Category}" ,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  //Container for the Gift Price
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: ListTile(
                      title: const Text(
                        "Price",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "${Price}",
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  Center(
                    child: showButton == true
                      ? ElevatedButton(
                      onPressed: () async {

                        bool isConnected = await internet.checkInternetConnection();
                        if (!isConnected) {
                          internet.showLoadingIndicator(context); // Show loading until connected
                          await internet.waitForInternetConnection(); // Wait for internet
                          Navigator.pop(context); // Close the loading dialog
                        }
                        String response = await giftController.toggleIsPledged(giftId, currentUserID, Name);
                        showMessage(context, response);

                        Navigator.pop(context, true);
                      },
                      child: Text(
                        isPledged ? 'Pledged' : 'Available',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: isPledged ? Colors.red : Colors.green,
                      ),
                    )
                      : ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context, true);
                      },
                      child: Text("Back",
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.purpleAccent[700],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
