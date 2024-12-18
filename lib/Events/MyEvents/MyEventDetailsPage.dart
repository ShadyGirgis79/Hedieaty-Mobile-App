import 'package:flutter/material.dart';
import 'package:hedieaty/Controller/EventController.dart';
import 'package:hedieaty/Controller/Functions/ShowMessage.dart';
import 'package:hedieaty/Controller/Services/Internet.dart';
import 'package:hedieaty/Model/Event_Model.dart';
import 'package:intl/intl.dart';

class MyEventDetails extends StatefulWidget {

  final Event event;
  const MyEventDetails({super.key, required this.event});


  @override
  State<MyEventDetails> createState() => _MyEventDetailsState();
}

class _MyEventDetailsState extends State<MyEventDetails> {
  final EventController eventController = EventController();
  final Internet internet = Internet();
  DateFormat dateFormat = DateFormat("dd-MM-yyyy");
  late String Name;
  late String Category;
  late String Description;
  late String Location;
  late String Status;
  late String Date;
  late int Publish;
  late int giftsNumber;
  late int eventId;

  @override
  void initState() {
    super.initState();
    // Initialize updated values with the current event details
    Name = widget.event.name;
    Category = widget.event.category;
    Description = widget.event.description;
    Location = widget.event.location;
    Status = widget.event.status;
    Date = widget.event.date;
    giftsNumber = widget.event.gifts.length;
    eventId = widget.event.id!;
    Publish = widget.event.publish!;
  }

  Future<void> saveUpdates() async {
    final response = await eventController.UpdateEvent(
        Name,
        Category,
        Description,
        Location,
        Date,
        Status,
        eventId
    );
    showMessage(context, response);

    // Update the UI and navigate back
    setState(() {
      widget.event.name = Name;
      widget.event.category = Category;
      widget.event.description = Description;
      widget.event.location = Location;
      widget.event.publish = Publish;
      widget.event.status = Status;
      widget.event.date = Date;
    });
  }

  final List<String> categoriesEvent = [
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${Name}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),),
        foregroundColor: Colors.white,
        backgroundColor: Colors.purpleAccent[700],
      ),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [

                  //Container for Name
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
                      subtitle: Text("${Name}" ,
                        style: TextStyle(
                          fontSize: 18,
                        ),),
                      leading: Icon(Icons.event),
                      trailing: Status == "Upcoming" || Status == "Current"?
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: (){
                              String updatedName = Name;

                              showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return AlertDialog(
                                      title: const Text("Event Name"),
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

                  //Container for Category
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
                      title: const Text(
                        "Category",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "${Category}",
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      leading: Icon(Icons.category),
                      trailing: Status == "Upcoming" || Status == "Current"
                          ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Initialize updatedCategory with a valid value
                              String updatedCategory = Category;

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Event Category"),
                                    content: SizedBox(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          DropdownButtonFormField<String>(
                                            value: updatedCategory,
                                            isExpanded: true,
                                            items: categoriesEvent.map((String category) {
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
                                },
                              );
                            },
                          ),
                        ],
                      )
                          : null, // Null when the event is not editable
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
                      subtitle: Text("${Description}" ,
                        style: TextStyle(
                          fontSize: 18,
                        ),),
                      leading: Icon(Icons.description),
                      trailing: Status == "Upcoming" || Status == "Current"?
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: (){
                              String updatedDescription = Description;

                              showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return AlertDialog(
                                      title: const Text("Description"),
                                      content: SizedBox(
                                        child: TextField(
                                          controller:TextEditingController(text: updatedDescription),
                                          onChanged: (value){
                                            updatedDescription = value;
                                          },
                                        ),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: (){
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

                  //Container for location
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
                      title: const Text("Location",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),),
                      subtitle: Text("${Location}" ,
                        style: TextStyle(
                          fontSize: 18,
                        ),),
                      leading: Icon(Icons.location_on_sharp),
                      trailing: Status == "Upcoming" || Status == "Current" ?
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: (){
                              String updatedLoc = Location;

                              showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return AlertDialog(
                                      title: const Text("Location"),
                                      content: SizedBox(
                                        child: TextField(
                                          controller: TextEditingController(text: updatedLoc),
                                          onChanged: (value){
                                            updatedLoc = value;
                                          },
                                        ),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: (){
                                            setState(() {
                                              Location = updatedLoc;
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

                  //Container for Date
                  // Container for Date
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
                        "Date",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "${Date}",
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      leading: const Icon(Icons.calendar_today),
                      trailing: Status == "Upcoming" || Status == "Current"
                          ? IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          // Allow the user to pick a new date
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: dateFormat.parse(Date), // Use the current date
                            firstDate: DateTime(2000), // Earliest date available
                            lastDate: DateTime(2100), // Latest date available
                          );

                          if (pickedDate != null) {
                            // Format the selected date as a string
                            String formattedDate = "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";

                            // Update the status based on the selected date
                            String updatedStatus;
                            DateTime currentDate = DateTime.now();
                            if (pickedDate.isBefore(currentDate)) {
                              updatedStatus = "Past";
                            }
                            else if (pickedDate.isAtSameMomentAs(currentDate) ||
                                pickedDate.isAfter(currentDate)) {
                              updatedStatus = "Upcoming";
                            }
                            else {
                              updatedStatus = "Current"; // This shouldn't happen logically
                            }

                            // Update the UI
                            setState(() {
                              Date = formattedDate;
                              Status = updatedStatus;
                            });
                          }
                        },
                      )
                          : null, // Null when the event is not editable
                    ),
                  ),

                  const SizedBox(height: 10),

                  //Container for Gifts
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
                        "Gifts",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "${giftsNumber}",
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      leading: const Icon(Icons.card_giftcard),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Center(
                    child: Publish == 0 && Status != "Past"
                    ?Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: (){
                            saveUpdates();
                            Navigator.pop(context , true); // Close the Details event page
                          },
                          child: Text("Save"),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.purpleAccent[700],
                          ),
                        ),

                        const SizedBox(width: 20),

                        ElevatedButton(
                          onPressed: () async {

                            bool isConnected = await internet.checkInternetConnection();
                            if (!isConnected) {
                              internet.showLoadingIndicator(context); // Show loading until connected
                              await internet.waitForInternetConnection(); // Wait for internet
                              Navigator.pop(context); // Close the loading dialog
                            }

                            saveUpdates();
                            await eventController.MakeEventPublic(eventId);

                            Navigator.pop(context , true);
                          },
                          child: const Text("Publish"),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.purpleAccent[700],
                          ),
                        ),
                      ],
                    )
                    : Status =='Past'
                        ?ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context , true);
                      },
                      child: const Text("Back"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.purpleAccent[700],
                      ),
                    )
                        :ElevatedButton(
                        onPressed: () async {

                          bool isConnected = await internet.checkInternetConnection();
                          if (!isConnected) {
                            internet.showLoadingIndicator(context); // Show loading until connected
                            await internet.waitForInternetConnection(); // Wait for internet
                            Navigator.pop(context); // Close the loading dialog
                          }

                          saveUpdates();
                          await eventController.MakeEventPublic(eventId);

                          Navigator.pop(context , true);
                        },
                        child: const Text("Save"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.purpleAccent[700],
                        ),
                      ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
      ),
    );
  }
}


