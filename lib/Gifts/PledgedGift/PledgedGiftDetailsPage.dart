
import 'package:flutter/material.dart';
import 'package:hedieaty/Gifts/FriendGift/FriendGiftsPage.dart';
import 'package:hedieaty/Model/Gift_Model.dart';
import 'dart:io';

class PledgedGiftDetails extends StatefulWidget {
  const PledgedGiftDetails({super.key});

  @override
  State<PledgedGiftDetails> createState() => _PledgedGiftDetailsState();
}

class _PledgedGiftDetailsState extends State<PledgedGiftDetails> {

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  String category = 'Books';
  bool isPledged = false;
  File? image;

  final categories = ['Electronics', 'Books', 'Toys', 'Souvenir', 'Accessories', 'Other'];

  // Initialize your Gift object here
  final Gift gift = Gift(
    name: "Teddy Bear",
    category: "Toys",
    status: "Pledged",
    price: 100,
  );

  @override
  void initState() {
    super.initState();
    nameController.text = gift.name;
    descriptionController.text = "Description here"; // Example description
    priceController.text = gift.price.toString();
    category = gift.category;
    isPledged = gift.status == "Pledged";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gift Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),),
        backgroundColor: Colors.purpleAccent,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child:Form(
              key: formKey,
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
                          child: image != null
                              ? Image.file(image!, height: 200, width: 200, fit: BoxFit.cover)
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
                        ),),
                      subtitle: Text("${gift.name}" ,
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
                        ),),
                      subtitle: Text("${descriptionController.text}" ,
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
                        ),),
                      subtitle: Text("${gift.category}" ,
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
                        "${gift.price}",
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  //Container for the Events
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
                        "Event",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "event belong to",
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  //Container for the Event Owner
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
                        "Event Owner",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Name",
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Pledged/Unpledged switch
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 20,),
                      const Text('Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),),
                      Switch(
                        value: isPledged,
                        onChanged: (value) {
                          setState(() {
                            isPledged = value;
                            gift.status = isPledged ? "Pledged" : "Unpledged";
                          });
                        },
                      ),
                      Text(isPledged ? 'Pledged' : 'Unpledged',
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),),
                      SizedBox(width: 20,),
                    ],
                  ),

                  //const Spacer(),
                  const SizedBox(height: 20),

                  // Save Gift button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // If the form is valid, save the data and navigate back
                          Navigator.pop(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FriendGiftsPage(),
                            ),
                          ); // Go back to GiftListPage
                        }
                        else {
                          // If form data is missing, show an error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill in all required fields')),
                          );
                        }
                      },
                      child: const Text('Save Gift',
                        style: TextStyle(
                          fontSize: 18,
                        ),),
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
      ),
    );
  }
}
