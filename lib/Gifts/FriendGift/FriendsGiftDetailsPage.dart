
import 'package:flutter/material.dart';
import 'package:hedieaty/Gifts/FriendGift/FriendsGiftListPage.dart';
import 'package:hedieaty/Model/Gift_Model.dart';
import 'dart:io';

class FriendsGiftDetails extends StatefulWidget {
  const FriendsGiftDetails({super.key});

  @override
  State<FriendsGiftDetails> createState() => _FriendsGiftDetailsState();
}

class _FriendsGiftDetailsState extends State<FriendsGiftDetails> {
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
                        // ElevatedButton(
                        //   onPressed: _isPledged ? null : () {
                        //     // _pickImage();
                        //   },
                        //   child: const Text('Upload Image'),
                        // ),
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

                      //trailing: !_isPledged ?
                      // Row(
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //     IconButton(
                      //       icon: const Icon(Icons.edit),
                      //       onPressed: (){
                      //         String updatedName = gift.name;
                      //
                      //         showDialog(
                      //             context: context,
                      //             builder: (BuildContext context){
                      //               return AlertDialog(
                      //                 title: const Text("Gift Name"),
                      //                 content: SizedBox(
                      //                   child: TextField(
                      //                     controller: TextEditingController(text: updatedName),
                      //                     onChanged: (value){
                      //                       updatedName = value;
                      //                     },
                      //                   ),
                      //                 ),
                      //                 actions: [
                      //                   ElevatedButton(
                      //                     onPressed: (){
                      //                       setState(() {
                      //                         gift.name = updatedName;
                      //                       });
                      //                       Navigator.of(context).pop();
                      //                     },
                      //                     child: const Text("Save Changes"),
                      //                   ),
                      //                 ],
                      //               );
                      //             }
                      //         );
                      //       },
                      //     )
                      //   ],
                      // )
                      //     : null, //Null when the gift is pledged

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
                      subtitle: Text("${_descriptionController.text}" ,
                        style: TextStyle(
                          fontSize: 18,
                        ),),

                      // trailing: !_isPledged ?
                      // Row(
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //     IconButton(
                      //       icon: const Icon(Icons.edit),
                      //       onPressed: (){
                      //         String updatedDescription = _descriptionController.text;
                      //
                      //         showDialog(
                      //             context: context,
                      //             builder: (BuildContext context){
                      //               return AlertDialog(
                      //                 title: const Text("Description"),
                      //                 content: SizedBox(
                      //                   child: TextField(
                      //                     controller: _descriptionController,
                      //                     onChanged: (value){
                      //                       updatedDescription = value;
                      //                     },
                      //                   ),
                      //                 ),
                      //                 actions: [
                      //                   ElevatedButton(
                      //                     onPressed: (){
                      //                       setState(() {
                      //                         _descriptionController.text = updatedDescription;
                      //                       });
                      //                       Navigator.of(context).pop();
                      //                     },
                      //                     child: const Text("Save Changes"),
                      //                   ),
                      //                 ],
                      //               );
                      //             }
                      //         );
                      //       },
                      //     )
                      //   ],
                      // )
                      //     : null, //Null when the gift is pledged

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

                      // trailing: !_isPledged ?
                      // Row(
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //     IconButton(
                      //       icon: const Icon(Icons.edit),
                      //       onPressed: (){
                      //         String updatedCategory = gift.category;
                      //
                      //         showDialog(
                      //             context: context,
                      //             builder: (BuildContext context){
                      //               return AlertDialog(
                      //                 title: const Text("Gift Category"),
                      //                 content: SizedBox(
                      //                   child: Column(
                      //                     mainAxisSize: MainAxisSize.min, // Minimize height to fit content
                      //                     children: [
                      //                       DropdownButtonFormField<String>(
                      //                         value: _category,
                      //                         items: _categories.map((String category) {
                      //                           return DropdownMenuItem<String>(
                      //                             value: category,
                      //                             child: Text(category),
                      //                           );
                      //                         }).toList(),
                      //                         onChanged: (value) {
                      //                           setState(() {
                      //                             updatedCategory = value!;
                      //                           });
                      //                         },
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //                 actions: [
                      //                   ElevatedButton(
                      //                     onPressed: (){
                      //                       setState(() {
                      //                         gift.category = updatedCategory;
                      //                         _category = updatedCategory;
                      //                       });
                      //                       Navigator.of(context).pop();
                      //                     },
                      //                     child: const Text("Save Changes"),
                      //                   ),
                      //                 ],
                      //               );
                      //             }
                      //         );
                      //       },
                      //     )
                      //   ],
                      // )
                      //     : null, //Null when the gift is pledged

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

                      // trailing: !_isPledged
                      //     ? IconButton(
                      //   icon: const Icon(Icons.edit),
                      //   onPressed: () {
                      //     int updatedPrice = gift.price;
                      //
                      //     showDialog(
                      //       context: context,
                      //       builder: (BuildContext context) {
                      //         return AlertDialog(
                      //           title: const Text("Edit Price"),
                      //           content: SizedBox(
                      //             //width: 200,
                      //             child: TextField(
                      //               controller: _priceController,
                      //               keyboardType: TextInputType.number,
                      //               inputFormatters: [
                      //                 FilteringTextInputFormatter.digitsOnly, // Only digits
                      //               ],
                      //               decoration: const InputDecoration(
                      //                 hintText: "Enter new price",
                      //               ),
                      //               onChanged: (value) {
                      //                 // Temporarily store the parsed value
                      //                 updatedPrice = int.tryParse(value) ?? gift.price;
                      //               },
                      //             ),
                      //           ),
                      //           actions: [
                      //             ElevatedButton(
                      //               onPressed: () {
                      //                 setState(() {
                      //                   // Update the price in the Gift object
                      //                   gift.price = updatedPrice;
                      //                 });
                      //                 Navigator.of(context).pop(); // Close dialog
                      //               },
                      //               child: const Text("Save Changes"),
                      //             ),
                      //           ],
                      //         );
                      //       },
                      //     );
                      //   },
                      // )
                      //     : null, //Null when the gift is pledged

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
                        value: _isPledged,
                        onChanged: (value) {
                          setState(() {
                            _isPledged = value;
                            gift.status = _isPledged ? "Pledged" : "Unpledged";
                          });
                        },
                      ),
                      Text(_isPledged ? 'Pledged' : 'Unpledged',
                        style: _isPledged?
                        TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                        ):
                          TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                          )
                      ),
                      SizedBox(width: 20,),
                    ],
                  ),

                  //const Spacer(),
                  const SizedBox(height: 20),

                  // Save Gift button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, save the data and navigate back
                          Navigator.pop(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FriendsGiftList(),
                            ),
                          ); // Go back to GiftListPage
                        } else {
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
                        backgroundColor: Colors.purpleAccent,
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
