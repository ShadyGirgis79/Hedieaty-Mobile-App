
import 'package:flutter/material.dart';
import 'package:hedieaty/Controller/AddEventController.dart';
import 'package:hedieaty/Controller/EventController.dart';
import 'package:hedieaty/Controller/Functions/ShowMessage.dart';
import 'package:hedieaty/Controller/Services/Internet.dart';

class AddEventPage extends StatefulWidget {

  const AddEventPage({super.key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locController = TextEditingController();
  final TextEditingController desController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final Internet internet = Internet();
  DateTime selectedDate = DateTime.now(); // To store the selected date
  final AddEventController addEventController = AddEventController();
  final EventController eventController = EventController();

  String selectedCategory = "General"; // Default category
  // Dropdown menu categories
  final List<String> categories = [
    "Birthday",
    "Wedding",
    "Corporate",
    "Graduation",
    "Valentine",
    "Christmas",
    "Ramadan",
    "Festival",
    "General",
    "Other"
  ];


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Event',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.purpleAccent[700],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Event Name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.event),
                  ),
                ),
                const SizedBox(height: 20),

                // Dropdown for category
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
                TextField(
                  controller: desController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: locController,
                  decoration: const InputDecoration(
                    labelText: "Location",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on_sharp),
                  ),
                ),
                const SizedBox(height: 20),

                //Date text field
                TextField(
                  controller: dateController,
                  readOnly: true, // Make the field read-only
                  decoration: InputDecoration(
                    labelText: "Event Date",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.calendar_today),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.edit_calendar),
                      onPressed: () async {
                        // Show date picker dialog
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                            // Format the date to a readable string
                            dateController.text =
                            "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                          });
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 70),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          String name = nameController.text.trim();
                          String category = selectedCategory;
                          String description = desController.text.trim();
                          String location = locController.text.trim();
                          String date = dateController.text.trim().toString();
                          String status = "";

                          if (selectedDate.day == DateTime.now().day &&
                              selectedDate.month == DateTime.now().month &&
                              selectedDate.year == DateTime.now().year) {
                            status = "Current";
                          }
                          else if (selectedDate.isAfter(DateTime.now())) {
                            status = "Upcoming";
                          }
                          else {
                            status = "Past";
                          }

                          final result = await addEventController.addEvent(
                            name: name,
                            category: category,
                            status: status,
                            date: date,
                            description: description,
                            location: location,
                          );

                          if (result == null) {
                            Navigator.pop(context , true); // Close the add event page
                          }
                          else {
                            showMessage(context, result);
                          }
                        },
                        child: const Text("Add Event"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.purpleAccent[700],
                        ),
                      ),

                      const SizedBox(width: 40),

                      ElevatedButton(
                        onPressed: () async {
                          String name = nameController.text.trim();
                          String category = selectedCategory;
                          String description = desController.text.trim();
                          String location = locController.text.trim();
                          String date = dateController.text.trim().toString();
                          String status = "";

                          if (selectedDate.day == DateTime.now().day &&
                              selectedDate.month == DateTime.now().month &&
                              selectedDate.year == DateTime.now().year) {
                            status = "Current";
                          }
                          else if (selectedDate.isAfter(DateTime.now())) {
                            status = "Upcoming";
                          }
                          else {
                            status = "Past";
                          }

                          bool isConnected = await internet.checkInternetConnection();
                          if (!isConnected) {
                            internet.showLoadingIndicator(context); // Show loading until connected
                            await internet.waitForInternetConnection(); // Wait for internet
                            Navigator.pop(context); // Close the loading dialog
                          }

                          final result = await addEventController.addEventPublic(
                            name: name,
                            category: category,
                            status: status,
                            date: date,
                            description: description,
                            location: location,
                          );


                          if (result == null) {
                            Navigator.pop(context , true); // Close the add event page
                          }
                          else {
                            showMessage(context, result);
                          }

                        },
                        child: const Text("Publish"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.purpleAccent[700],
                        ),
                      ),
                    ],
                  ) ,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
