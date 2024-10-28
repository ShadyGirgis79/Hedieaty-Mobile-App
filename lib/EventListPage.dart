
import 'package:flutter/material.dart';

class Event {
  String name;
  String category;
  String status; // "Upcoming", "Current", or "Past"
  int gifts =0 ;

  Event({required this.name, required this.category, required this.status , required this.gifts});
}

class EventListPage extends StatefulWidget {
  const EventListPage({Key? key}) : super(key: key);

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  List<Event> events = [
    Event(name: "Birthday Party", category: "Personal", status: "Upcoming" , gifts: 3),
    Event(name: "Project Meeting", category: "Work", status: "Past",gifts: 5),
    Event(name: "Conference", category: "Professional", status: "Current",gifts: 2),
  ];

  String sortBy = 'name';

  void _addEvent() {
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
              TextField(
                decoration: const InputDecoration(labelText: "Category"),
                onChanged: (value) {
                  category = value;
                },
              ),
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

  void _editEvent(Event event) {
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
              TextField(
                decoration: const InputDecoration(labelText: "Category"),
                controller: TextEditingController(text: updatedCategory),
                onChanged: (value) {
                  updatedCategory = value;
                },
              ),
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


  void _deleteEvent(Event event) {
    setState(() {
      events.remove(event);
    });
  }

  int _statusPriority(String status) {
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

  void _sortEvents(String sortBy) {
    setState(() {
      this.sortBy = sortBy;
      events.sort((a, b) {
        switch (sortBy) {
          case 'name':
            return a.name.compareTo(b.name);
          case 'category':
            return a.category.compareTo(b.category);
          case 'status':
            return _statusPriority(a.status).compareTo(_statusPriority(b.status));
          default:
            return 0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event List'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.purpleAccent,
        actions: [
          PopupMenuButton<String>(
            onSelected: _sortEvents,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'name', child: Text('Sort by Name')),
              const PopupMenuItem(value: 'category', child: Text('Sort by Category')),
              const PopupMenuItem(value: 'status', child: Text('Sort by Status')),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return ListTile(
            title: Text('${event.name} (${event.gifts})'),
            subtitle: Text('${event.category} • ${event.status}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editEvent(event),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteEvent(event),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        child: const Icon(Icons.add),
      ),
    );
  }
}

