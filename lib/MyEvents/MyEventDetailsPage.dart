import 'package:flutter/material.dart';

import '../Model/Event_Model.dart';

class MyEventDetails extends StatefulWidget {
  const MyEventDetails({super.key});

  @override
  State<MyEventDetails> createState() => _MyEventDetailsState();
}

class _MyEventDetailsState extends State<MyEventDetails> {

  final Event event = Event(
    name: "Party",
    category: "Birthday Party",
    status: "Upcoming",
    description: "",
    location: "",
    date: '',
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${event.name}",
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
                      subtitle: Text("${event.name}" ,
                        style: TextStyle(
                          fontSize: 18,
                        ),),
                      leading: Icon(Icons.event),
                      trailing: event.status == "Upcoming" ?
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: (){
                              String updatedName = event.name;

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
                                              event.name = updatedName;
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
                      subtitle: Text("${event.category}" ,
                        style: TextStyle(
                          fontSize: 18,
                        ),),
                      leading: Icon(Icons.category),
                      trailing: event.status == "Upcoming" ?
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: (){
                              String updatedCategory = event.category;

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
                                              event.category = updatedCategory;
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
                      subtitle: Text("${event.description}" ,
                        style: TextStyle(
                          fontSize: 18,
                        ),),
                      leading: Icon(Icons.description),
                      trailing: event.status == "Upcoming" ?
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: (){
                              String updatedDescription = event.description;

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
                                              event.description = updatedDescription;
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
                      subtitle: Text("${event.location}" ,
                        style: TextStyle(
                          fontSize: 18,
                        ),),
                      leading: Icon(Icons.location_on_sharp),
                      trailing: event.status == "Upcoming" ?
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: (){
                              String updatedLoc = event.location;

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
                                              event.location = updatedLoc;
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
                        "${event.date}",
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      leading: const Icon(Icons.calendar_today),
                      trailing: event.status == "Upcoming"
                          ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              // Show DatePicker
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                //initialDate: event.date,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null && pickedDate != event.date) {
                                setState(() {
                                  //event.date = pickedDate;
                                });
                              }
                            },
                          )
                        ],
                      )
                          : null, // Null when the event is not editable
                    ),
                  ),


                  const SizedBox(height: 60),

                  Center(
                    child: ElevatedButton(
                        onPressed: (){

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
