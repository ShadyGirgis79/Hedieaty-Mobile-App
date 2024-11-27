
import 'package:flutter/material.dart';
import 'package:hedieaty/Gifts/MyGiftListPage.dart';
import 'package:hedieaty/Model/Event_Model.dart';
import 'package:hedieaty/Model/Gift_Model.dart';

class MyEventsList extends StatefulWidget {
  const MyEventsList({super.key});

  @override
  State<MyEventsList> createState() => _MyEventsListState();
}

class _MyEventsListState extends State<MyEventsList> {
  List<Event> events = [
    Event(
      name: "Charity Auction",
      category: "Community",
      status: "Past",
      date: DateTime(2023, 12, 25),
      gifts: [
        Gift(name: "Painting", category: "Art", status: "Unpledged", price: 1200),
        Gift(name: "Handmade Bag", category: "Craft", status: "Pledged", price: 500),
      ],
    ),
    Event(
      name: "Birthday Party",
      category: "Personal",
      status: "Upcoming",
      date: DateTime(2023, 12, 25),
      gifts: [
        Gift(name: "Teddy Bear", category: "Toy", status: "Pledged", price: 100),
        Gift(name: "Phone", category: "Electronics", status: "Unpledged", price: 24000),
        Gift(name: "Watch", category: "Electronics", status: "Unpledged", price: 8500),
        Gift(name: "Teddy Bear", category: "Toy", status: "Pledged", price: 100),
        Gift(name: "Phone", category: "Electronics", status: "Unpledged", price: 24000),
        Gift(name: "Watch", category: "Electronics", status: "Unpledged", price: 8500),
        Gift(name: "Teddy Bear", category: "Toy", status: "Pledged", price: 100),
        Gift(name: "Phone", category: "Electronics", status: "Unpledged", price: 24000),
        Gift(name: "Watch", category: "Electronics", status: "Unpledged", price: 8500),
        Gift(name: "Teddy Bear", category: "Toy", status: "Pledged", price: 100),
        Gift(name: "Phone", category: "Electronics", status: "Unpledged", price: 24000),
        Gift(name: "Watch", category: "Electronics", status: "Unpledged", price: 8500),
      ],
    ),
    Event(
      name: "Project Meeting",
      category: "Work",
      status: "Past",
      date: DateTime(2023, 12, 25),
      gifts: [
        Gift(name: "Harry Potter", category: "Books", status: "Pledged", price: 70),
        Gift(name: "Bracelet", category: "Accessories", status: "Pledged", price: 350),
      ],
    ),
    Event(
      name: "Conference",
      category: "Professional",
      status: "Current",
      date: DateTime(2023, 12, 25),
    ),
    Event(
      name: "Wedding",
      category: "Family",
      status: "Upcoming",
      date: DateTime(2023, 12, 25),
      gifts: [
        Gift(name: "Necklace", category: "Jewelry", status: "Pledged", price: 5000),
        Gift(name: "Dinner Set", category: "Home", status: "Unpledged", price: 3000),
      ],
    ),
    Event(
      name: "Team Building Retreat",
      category: "Work",
      status: "Past",
      date: DateTime(2023, 12, 25),
      gifts: [
        Gift(name: "Coffee Mug", category: "Accessories", status: "Pledged", price: 150),
      ],
    ),
    Event(
      name: "Baby Shower",
      category: "Family",
      status: "Upcoming",
      date: DateTime(2023, 12, 25),
      gifts: [
        Gift(name: "Baby Stroller", category: "Childcare", status: "Unpledged", price: 15000),
        Gift(name: "Diaper Bag", category: "Accessories", status: "Pledged", price: 2500),
      ],
    ),
    Event(
      name: "Book Club",
      category: "Hobby",
      status: "Past",
      date: DateTime(2023, 12, 25),
      gifts: [
        Gift(name: "Novel", category: "Books", status: "Pledged", price: 300),
      ],
    ),
  ];

  String sortBy = 'name';

  void sortEvents(String sortBy) {
    setState(() {
      this.sortBy = sortBy;
      events.sort((a, b) {
        switch (sortBy) {
          case 'name':
            return a.name.compareTo(b.name);
          case 'category':
            return a.category.compareTo(b.category);
          case 'status':
            return statusPriority(a.status).compareTo(statusPriority(b.status));
          default:
            return 0;
        }
      });
    });
  }

  int statusPriority(String status) {
    switch (status) {
      case 'Upcoming':
        return 1;
      case 'Current':
        return 2;
      case 'Past':
        return 3;
      default:
        return 4;
    }
  }

  void addEventCallback(Event event) {
    setState(() {
      events.add(event);  // Update the events list
    });
  }

  void addEvent() {
    String name = "";
    String category = "";
    String status = 'Upcoming';
    DateTime date = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Add Event"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: "Name"),
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(labelText: "Category"),
                    onChanged: (value) {
                      category = value;
                    },
                  ),
                  const SizedBox(height: 10),

                  // DropdownButtonFormField<String>(
                  //   decoration: const InputDecoration(labelText: "Status"),
                  //   value: status,
                  //   onChanged: (String? newValue) {
                  //     setState(() {
                  //       status = newValue!;
                  //     });
                  //   },
                  //   items: <String>['Upcoming', 'Current', 'Past']
                  //       .map<DropdownMenuItem<String>>((String value) {
                  //     return DropdownMenuItem<String>(
                  //       value: value,
                  //       child: Text(value),
                  //     );
                  //   }).toList(),
                  // ),

                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Date: ${date.toLocal().toString().split(' ')[0]}",
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null && pickedDate != date) {
                            setState(() {
                              date = pickedDate;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (name.isNotEmpty && category.isNotEmpty) {
                      setState(() {
                        if(date.month == DateTime.now().month){
                          status = "Current";
                        }
                        else if (date.isAfter(DateTime.now()))
                          {
                            status = "Upcoming";
                          }
                        else{
                          status = "Past";
                        }
                        addEventCallback(Event(
                          name: name,
                          category: category,
                          status: status,
                          date: date,
                        ));
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Add"),
                ),
                SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: const Text("Back"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void editEvent(Event event) {
    // Temporary variables to hold new values for the event.
    String updatedName = event.name;
    String updatedCategory = event.category;
    //String updatedStatus = event.status;
    DateTime updateDate =event.date;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Event"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Name"),
                controller: TextEditingController(text: updatedName),
                onChanged: (value) {
                  updatedName = value;
                },
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(labelText: "Category"),
                controller: TextEditingController(text: updatedCategory),
                onChanged: (value) {
                  updatedCategory = value;
                },
              ),
              const SizedBox(height: 10),
              // DropdownButtonFormField<String>(
              //   decoration: const InputDecoration(labelText: "Status"),
              //   value: updatedStatus,
              //   onChanged: (String? newValue) {
              //     updatedStatus = newValue!;
              //   },
              //   items: <String>['Upcoming', 'Current', 'Past']
              //       .map<DropdownMenuItem<String>>((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(value),
              //     );
              //   }).toList(),
              // ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Date: ${updateDate.toLocal().toString().split(' ')[0]}",
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: updateDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null && pickedDate != updateDate) {
                        setState(() {
                          updateDate = pickedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Update the event's properties with the new values
                  event.name = updatedName;
                  event.category = updatedCategory;
                  if(event.date.month == DateTime.now().month){
                    //If the event is on the same month as the current time then it is current
                    event.status = 'Current';
                  }
                  else if(event.date.isAfter(DateTime.now())){
                    event.status = "Upcoming";
                  }
                  else{
                    event.status = "Past";
                  }
                  event.date = updateDate;
                });
                Navigator.of(context).pop();
              },
              child: const Text("Save Changes"),
            ),
            SizedBox(width: 10,),
            ElevatedButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: const Text("Back"),
            ),
          ],
        );
      },
    );
  }

  void deleteEvent(Event event) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Are you sure you want to delete?"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      events.remove(event);
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("Delete"),
              ),
              SizedBox(width: 10,),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")
              ),
            ],
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Events List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),),
        foregroundColor: Colors.white,
        backgroundColor: Colors.purpleAccent,
        actions: [
          PopupMenuButton<String>(
            onSelected: sortEvents,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'name', child: Text('Sort by Name')),
              const PopupMenuItem(value: 'category', child: Text('Sort by Category')),
              const PopupMenuItem(value: 'status', child: Text('Sort by Status')),
            ],
          ),
        ],
      ),
      body: SafeArea(
          child: ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Container(
                decoration: BoxDecoration(
                  color: event.status == "Past" ? Color(0xFF9393FF) : Color(0xABABFFFF),
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: ListTile(
                  title: Text('${event.name}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),),
                  subtitle: Text('${event.category} • ${event.status}',
                    style: TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),),
                  trailing: event.status == "Past"?
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        //color: Colors.red,
                        onPressed: () => deleteEvent(event),
                      ),
                    ],
                  )
                      :Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => editEvent(event),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        //color: Colors.red,
                        onPressed: () => deleteEvent(event),
                      ),
                    ],
                  ),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyGiftList(),
                      ),
                    );
                  },
                ),
              );
            },
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addEvent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
