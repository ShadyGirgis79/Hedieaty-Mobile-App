import 'package:flutter/material.dart';
import 'package:hedieaty/Controller/EventController.dart';
import 'package:hedieaty/Controller/ShowMessage.dart';
import 'package:hedieaty/Model/Event_Model.dart';

class MyEventDetails extends StatefulWidget {

  final Event event;
  const MyEventDetails({super.key, required this.event});


  @override
  State<MyEventDetails> createState() => _MyEventDetailsState();
}

class _MyEventDetailsState extends State<MyEventDetails> {
  final EventController eventController = EventController();
  late String Name;
  late String Category;
  late String Description;
  late String Location;
  late String Status;
  late String Date;
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
    eventId = widget.event.id!;
  }

  Future<void> saveUpdates() async {

    final response = await eventController.UpdateEvent(
        Name,
        Category,
        Description,
        Location,
        eventId
    );

    showMessage(context, response);

    // Update the UI and navigate back
    setState(() {
      widget.event.name = Name;
      widget.event.category = Category;
      widget.event.description = Description;
      widget.event.location = Location;
    });

    Navigator.of(context).pop();
  }


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
                      subtitle: Text("${Category}" ,
                        style: TextStyle(
                          fontSize: 18,
                        ),),
                      leading: Icon(Icons.category),
                      trailing: Status == "Upcoming" || Status == "Current"?
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: (){
                              String updatedCategory = Category;

                              showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return AlertDialog(
                                      title: const Text("Event Category"),
                                      content: SizedBox(
                                        child: TextField(
                                          controller: TextEditingController(text: updatedCategory),
                                          onChanged: (value){
                                            updatedCategory = value;
                                          },
                                        ),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: (){
                                            setState(() {
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
                    ),
                  ),


                  const SizedBox(height: 60),

                  Center(
                    child: ElevatedButton(
                      onPressed: (){
                        saveUpdates();
                      },
                      child: Text("Save"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.purpleAccent[700],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}


