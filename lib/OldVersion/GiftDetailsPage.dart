import 'package:flutter/material.dart';
import 'package:hedieaty/Model/Gift_Model.dart';
import 'dart:io';

// Uncomment if you're using the image picker
// import 'package:image_picker/image_picker.dart';

class GiftDetailsPage extends StatefulWidget {
  const GiftDetailsPage({super.key});

  @override
  State<GiftDetailsPage> createState() => _GiftDetailsPageState();
}

class _GiftDetailsPageState extends State<GiftDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  String _category = 'Books';
  bool _isPledged = false;
  File? _image;

  final _categories = ['Electronics', 'Books', 'Toys', 'Souvenir', 'Accessories', 'Other'];

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
    _nameController.text = gift.name;
    _descriptionController.text = "Description here"; // Example description
    _priceController.text = gift.price.toString();
    _category = gift.category;
    _isPledged = gift.status == "Pledged";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gift Details'),
        backgroundColor: Colors.purpleAccent,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child:Form(
              key: _formKey,
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
                              color: _isPledged ? Colors.red : Colors.green,
                              width: 12.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _image != null
                              ? Image.file(_image!, height: 200, width: 200, fit: BoxFit.cover)
                              : const Icon(Icons.image, size: 200, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _isPledged ? null : () {
                            // _pickImage();
                          },
                          child: const Text('Upload Image'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Name field with edit icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Gift Name'),
                          enabled: !_isPledged,
                          validator: (value) => value == null || value.isEmpty ? 'Please enter a gift name' : null,
                          onChanged: (value) {
                            setState(() {
                              gift.name = value;
                            });
                          },
                        ),
                      ),
                      // if (!_isPledged)
                      //   IconButton(
                      //     icon: const Icon(Icons.edit),
                      //     onPressed: () {
                      //       setState(() {
                      //         _nameController.text = gift.name;
                      //       });
                      //     },
                      //   ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Description field with edit icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(labelText: 'Description'),
                          enabled: !_isPledged,
                          onChanged: (value) {
                            // Update description here if needed
                          },
                        ),
                      ),
                      // if (!_isPledged)
                      //   IconButton(
                      //     icon: const Icon(Icons.edit),
                      //     onPressed: () {
                      //       setState(() {
                      //         _descriptionController.text = "New description here";
                      //       });
                      //     },
                      //   ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Category dropdown with edit icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _category,
                          decoration: const InputDecoration(labelText: 'Category'),
                          items: _categories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: _isPledged ? null : (value) {
                            setState(() {
                              _category = value!;
                              gift.category = value;
                            });
                          },
                        ),
                      ),
                      // if (!_isPledged)
                      //   IconButton(
                      //     icon: const Icon(Icons.edit),
                      //     onPressed: () {
                      //       setState(() {
                      //         _category = gift.category;
                      //       });
                      //     },
                      //   ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Price field with edit icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _priceController,
                          decoration: const InputDecoration(labelText: 'Price'),
                          enabled: !_isPledged,
                          keyboardType: TextInputType.number,
                          validator: (value) => value == null || value.isEmpty ? 'Please enter a price' : null,
                          onChanged: (value) {
                            setState(() {
                              gift.price = int.tryParse(value) ?? gift.price;
                            });
                          },
                        ),
                      ),
                      // if (!_isPledged)
                      //   IconButton(
                      //     icon: const Icon(Icons.edit),
                      //     onPressed: () {
                      //       setState(() {
                      //         _priceController.text = gift.price.toString();
                      //       });
                      //     },
                      //   ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Pledged/Unpledged switch
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Status'),
                      Switch(
                        value: _isPledged,
                        onChanged: (value) {
                          setState(() {
                            _isPledged = value;
                            gift.status = _isPledged ? "Pledged" : "Available";
                          });
                        },
                      ),
                      Text(_isPledged ? 'Pledged' : 'Available'),
                    ],
                  ),

                  //const Spacer(),
                  const SizedBox(height: 40),

                  // Save Gift button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, save the data and navigate back
                          Navigator.pop(context); // Go back to GiftListPage
                        } else {
                          // If form data is missing, show an error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill in all required fields')),
                          );
                        }
                      },
                      child: const Text('Save Gift'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
