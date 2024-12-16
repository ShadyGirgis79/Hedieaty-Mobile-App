
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hedieaty/Controller/Functions/ShowMessage.dart';
import 'package:hedieaty/Controller/GiftController.dart';
import 'package:hedieaty/Model/Gift_Model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MyGiftDetails extends StatefulWidget {
  final Gift gift;
  const MyGiftDetails({super.key, required this.gift});

  @override
  State<MyGiftDetails> createState() => _MyGiftDetailsState();
}

class _MyGiftDetailsState extends State<MyGiftDetails> {
  final int currentUserID = FirebaseAuth.instance.currentUser!.uid.hashCode;
  final GiftController giftController = GiftController();
  final ImagePicker picker = ImagePicker();
  bool isPledged = false;

  late String Name;
  late String Category;
  late String Status;
  late String Description;
  String? ImageURL;
  XFile? image;
  late double Price;
  late int giftId;

  final categoriesGift = [
    'Electronics',
    'Books',
    'Toys',
    'Souvenir',
    'Accessories',
    'Other'
  ];

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
    isPledged = Status != "Available";
  }

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          image = pickedFile;
          ImageURL = pickedFile.path;
        });
      }
    }
    catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Future<void> saveUpdate() async {
    final response = await giftController.UpdateGift(
      Name,
      Category,
      Description,
      Status,
      Price,
      ImageURL ?? "",
      giftId,
    );

    showMessage(context, response);

    setState(() {
      widget.gift.name = Name;
      widget.gift.category = Category;
      widget.gift.description = Description;
      widget.gift.status = Status;
      widget.gift.price = Price;
      widget.gift.imageURL = ImageURL!;
    });

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${Name} Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
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
                            color: Colors.grey,
                            width: 12.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ImageURL != ""
                            ? Image.file(File(ImageURL!), height: 200, width: 200, fit: BoxFit.cover,)
                            : const Icon(Icons.image, size: 200, color: Colors.grey,),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: pickImage,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text("Upload Image"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.purpleAccent[700],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Gift Name
                //Container for the Gift Name
                Container(
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                    //borderRadius: BorderRadius.circular(8.0),
                  ),
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  child: ListTile(
                    title: const Text("Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),),
                    subtitle: Text("${Name}",
                      style: TextStyle(
                        fontSize: 18,
                      ),),
                    trailing: !isPledged ?
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            String updatedName = Name;

                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Gift Name"),
                                    content: SizedBox(
                                      child: TextField(
                                        controller: TextEditingController(
                                            text: updatedName),
                                        onChanged: (value) {
                                          updatedName = value;
                                        },
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            Name = updatedName;
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
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                    //borderRadius: BorderRadius.circular(8.0),
                  ),
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  child: ListTile(
                    title: const Text("Description",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),),
                    subtitle: Text("${Description}",
                      style: TextStyle(
                        fontSize: 18,
                      ),),
                    trailing: !isPledged ?
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            String updatedDescription = Description;

                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Description"),
                                    content: SizedBox(
                                      child: TextField(
                                        controller: TextEditingController(
                                            text: updatedDescription),
                                        onChanged: (value) {
                                          updatedDescription = value;
                                        },
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            Description = updatedDescription;
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
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                    //borderRadius: BorderRadius.circular(8.0),
                  ),
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  child: ListTile(
                    title: const Text("Category",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),),
                    subtitle: Text("${Category}",
                      style: TextStyle(
                        fontSize: 18,
                      ),),
                    trailing: !isPledged ?
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            String updatedCategory = Category;

                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Gift Category"),
                                    content: SizedBox(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        // Minimize height to fit content
                                        children: [
                                          DropdownButtonFormField<String>(
                                            value: updatedCategory,
                                            isExpanded: true,
                                            items: categoriesGift.map((
                                                String category) {
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
                                        onPressed: () {
                                          this.setState(() {
                                            Category = updatedCategory;
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
                      "\$${Price.toStringAsFixed(2)}", // Display price as a formatted string
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    trailing: !isPledged
                        ? IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        double updatedPrice = Price;

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            TextEditingController priceController =
                            TextEditingController(text: updatedPrice.toString());

                            return AlertDialog(
                              title: const Text("Edit Price"),
                              content: SizedBox(
                                child: TextField(
                                  controller: priceController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                                    // Allow digits and decimal point
                                  ],
                                  decoration: const InputDecoration(
                                    hintText: "Enter new price",
                                  ),
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      updatedPrice = double.tryParse(priceController.text) ??
                                          Price; // Parse input or keep original
                                      Price = updatedPrice; // Update the price
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
                        : null, // Null when the gift is pledged
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
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
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
                        : Text(
                      "Name",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const SizedBox(height: 20),

                // Save Gift Button
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: saveUpdate,
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.purpleAccent[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

