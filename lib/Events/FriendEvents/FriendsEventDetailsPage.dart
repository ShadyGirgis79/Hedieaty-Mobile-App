
import 'package:flutter/material.dart';
import 'package:hedieaty/Controller/EventController.dart';
import 'package:hedieaty/Model/Event_Model.dart';

class FriendsEventDetailsPage extends StatefulWidget {
  final Event event;
  const FriendsEventDetailsPage({super.key, required this.event});

  @override
  State<FriendsEventDetailsPage> createState() => _FriendsEventDetailsPageState();
}

class _FriendsEventDetailsPageState extends State<FriendsEventDetailsPage> {
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
                ],
              ),
            ),
          )
      ),
    );
  }
}
