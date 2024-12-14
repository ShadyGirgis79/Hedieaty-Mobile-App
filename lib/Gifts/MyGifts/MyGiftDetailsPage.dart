
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hedieaty/Controller/ShowMessage.dart';
import 'package:hedieaty/Gifts/MyGifts/MyGiftsPage.dart';
import 'package:hedieaty/Model/Gift_Model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class MyGiftDetails extends StatefulWidget {
  const MyGiftDetails({super.key});

  @override
  State<MyGiftDetails> createState() => _MyGiftDetailsState();
}

class _MyGiftDetailsState extends State<MyGiftDetails> {
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
    isPledged = gift.status == "Unpledged";
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
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
        backgroundColor: Colors.purpleAccent[700],
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

                        ElevatedButton.icon(
                          onPressed: (){
                            _pickImage();
                          }, // Call pickImage function
                          icon: const Icon(Icons.camera_alt),
                          label: const Text("Upload Image///Image/label"),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.purpleAccent[700],
                          ),
                        ),
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
                        ),),
                      trailing: !isPledged ?
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: (){
                              String updatedName = gift.name;

                              showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return AlertDialog(
                                      title: const Text("Gift Name"),
                                      content: SizedBox(
                                        child: TextField(
                                          controller: TextEditingController(text: updatedName),
                                          onChanged: (value){
                                            updatedName = value;
                                          },
                                        ),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: (){
                                            setState(() {
                                              gift.name = updatedName;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Save Changes"),
                                        ),
                                      ],
                                    );
                                  }
                              );
                            },
                          )
                        ],
                      )
                      : null, //Null when the gift is pledged
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
                        ),),
                      trailing: !isPledged ?
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: (){
                              String updatedDescription = descriptionController.text;

                              showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return AlertDialog(
                                      title: const Text("Description"),
                                      content: SizedBox(
                                        child: TextField(
                                          controller: descriptionController,
                                          onChanged: (value){
                                            updatedDescription = value;
                                          },
                                        ),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: (){
                                            setState(() {
                                              descriptionController.text = updatedDescription;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Save Changes"),
                                        ),
                                      ],
                                    );
                                  }
                              );
                            },
                          )
                        ],
                      )
                          : null, //Null when the gift is pledged
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
                        ),),
                      trailing: !isPledged ?
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: (){
                              String updatedCategory = gift.category;

                              showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return AlertDialog(
                                      title: const Text("Gift Category"),
                                      content: SizedBox(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min, // Minimize height to fit content
                                          children: [
                                            DropdownButtonFormField<String>(
                                              value: category,
                                              items: categories.map((String category) {
                                                return DropdownMenuItem<String>(
                                                  value: category,
                                                  child: Text(category),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  updatedCategory = value!;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: (){
                                            setState(() {
                                              gift.category = updatedCategory;
                                              category = updatedCategory;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Save Changes"),
                                        ),
                                      ],
                                    );
                                  }
                              );
                            },
                          )
                        ],
                      )
                          : null, //Null when the gift is pledged
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
                      trailing: !isPledged
                          ? IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          double updatedPrice = gift.price;

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Edit Price"),
                                content: SizedBox(
                                  //width: 200,
                                  child: TextField(
                                    controller: priceController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly, // Only digits
                                    ],
                                    decoration: const InputDecoration(
                                      hintText: "Enter new price",
                                    ),
                                    onChanged: (value) {
                                      // Temporarily store the parsed value
                                      updatedPrice = double.tryParse(value) ?? gift.price;
                                    },
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        // Update the price in the Gift object
                                        gift.price = updatedPrice;
                                      });
                                      Navigator.of(context).pop(); // Close dialog
                                    },
                                    child: const Text("Save Changes"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      )
                          : null, //Null when the gift is pledged
                    ),
                  ),

                  const SizedBox(height: 10),

                  //Container for the person who pledged the gift
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
                        "Pledged By",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: !isPledged ?
                      Text(
                        "...............",
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      )
                      :Text(
                        "Name",
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

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
                              builder: (context) => MyGiftsPage(),
                            ),
                          );// Go back to GiftListPage
                        } else {
                          // If form data is missing, show an error message
                          showMessage(context, 'Please fill in all required fields');
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
