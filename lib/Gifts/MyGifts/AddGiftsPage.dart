
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hedieaty/Controller/AddGiftController.dart';
import 'package:hedieaty/Controller/Functions/ShowMessage.dart';
import 'package:image_picker/image_picker.dart';

class AddGiftPage extends StatefulWidget {
  final int eventId; // Pass the Event ID to associate the gift
  final String eventName;
  const AddGiftPage({super.key, required this.eventId, required this.eventName});

  @override
  State<AddGiftPage> createState() => _AddGiftPageState();
}

class _AddGiftPageState extends State<AddGiftPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController desController = TextEditingController();
  final AddGiftController addGiftController = AddGiftController();
  late int EventId;
  late String EventName;
  String selectedCategory = 'Books';
  File? image;

  final List<String> categories = [
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
    EventId = widget.eventId;
    EventName = widget.eventName;
  }

  // Function to pick an image
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
        title: const Text(
          "Add Gift",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
          ),
        ),
        backgroundColor: Colors.purpleAccent[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: (){

          },
              icon: Icon(Icons.camera_alt)
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Image Container
              Center(
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.purpleAccent,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: image != null
                      ? Image.file(image!, height: 200, width: 200, fit: BoxFit.cover)
                      : const Icon(Icons.image, size: 200, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),

              // Upload Image Button
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.camera_alt),
                label: const Text("Upload Image"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent[700],
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              // Gift Name Input
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Gift Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.card_giftcard),
                ),
              ),
              const SizedBox(height: 20),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories
                    .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
              ),
              const SizedBox(height: 20),

              // Description Input
              TextField(
                controller: desController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
              ),
              const SizedBox(height: 20),

              // Price Input
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: "Price",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
              ),
              const SizedBox(height: 50),

              // Save Button
              ElevatedButton(
                onPressed: () async{
                  final String name = nameController.text.trim();
                  final String description = desController.text.trim();
                  final String priceText = priceController.text.trim();
                  final double? price = double.tryParse(priceText);
                  final String status = "Available";
                  final int pledgedId = 0;

                  final result = await addGiftController.addGift(
                    name: name,
                    category: selectedCategory,
                    description: description,
                    image: image?.path ?? "", // Save the image path or an empty string if no image
                    price: price!,
                    status: status,
                    eventId: EventId,
                    pledgedId: pledgedId,
                  );

                  if (result == null) {
                    Navigator.pop(context , true); // Close the add event page
                  }
                  else {
                    showMessage(context, result);
                  }


                },
                child: const Text("Add Gift"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent[700],
                  foregroundColor: Colors.white,

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
