
import 'package:flutter/material.dart';
import 'package:hedieaty/Model/Event_Model.dart';

class MyEventsList extends StatefulWidget {
  const MyEventsList({super.key});

  @override
  State<MyEventsList> createState() => _MyEventsListState();
}

class _MyEventsListState extends State<MyEventsList> {
  List<Event> events = [
    Event(name: "Birthday Party", category: "Personal", status: "Upcoming" , gifts: 3),
    Event(name: "Project Meeting", category: "Work", status: "Past",gifts: 5),
    Event(name: "Conference", category: "Professional", status: "Current",gifts: 2),
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

  void addEvent() {
    String name = "";
    String category = "";
    String status = 'Upcoming';
    int gifts = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Status"),
                value: status,
                onChanged: (String? newValue) {
                  status = newValue!;
                },
                items: <String>['Upcoming', 'Current', 'Past']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (name.isNotEmpty && category.isNotEmpty) {
                  setState(() {
                    events.add(Event(name: name, category: category, status: status, gifts: gifts));
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void editEvent(Event event) {
    // Temporary variables to hold new values for the event.
    String updatedName = event.name;
    String updatedCategory = event.category;
    String updatedStatus = event.status;
    int updatedGifts = event.gifts;

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
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Status"),
                value: updatedStatus,
                onChanged: (String? newValue) {
                  updatedStatus = newValue!;
                },
                items: <String>['Upcoming', 'Current', 'Past']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
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
                  event.status = updatedStatus;
                  event.gifts = updatedGifts;
                });
                Navigator.of(context).pop();
              },
              child: const Text("Save Changes"),
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
        title: const Text('My Events List'),
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
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: ListTile(
                  title: Text('${event.name}'),
                  subtitle: Text('${event.category} • ${event.status}'),
                  trailing: Row(
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
                    Navigator.pushNamed(context, '/MyGiftList');
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
