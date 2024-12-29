import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/Controller/EventController.dart';
import 'package:hedieaty/Controller/Functions/ShowMessage.dart';
import 'package:hedieaty/Controller/GiftController.dart';
import 'package:hedieaty/Events/MyEvents/AddEventPage.dart';
import 'package:hedieaty/Events/MyEvents/MyEventDetailsPage.dart';
import 'package:hedieaty/Gifts/MyGifts/MyGiftsPage.dart';
import 'package:hedieaty/Model/Event_Model.dart';
import 'package:intl/intl.dart';

class MyEventPage extends StatefulWidget {
  const MyEventPage({super.key});

  @override
  State<MyEventPage> createState() => _MyEventPageState();
}

class _MyEventPageState extends State<MyEventPage> {
  final String currentUserID = FirebaseAuth.instance.currentUser!.uid;
  final EventController eventController = EventController();
  TextEditingController searchController = TextEditingController();
  final GiftController giftController = GiftController();
  DateFormat dateFormat = DateFormat("dd-MM-yyyy");
  List<Event> events = [];
  List<Event> filteredEvents = [];
  String sortBy = 'name';

  @override
  void initState() {
    super.initState();
    searchController.addListener(searchEvents);
    loadEvents(); // Load events when the page is initialized
  }

  Future<void> loadEvents() async {
    final fetchedEvents = await eventController.eventsList();
    setState(() {
      events = fetchedEvents?.map((event) {
        // Parse the event's date
        DateTime eventDate = dateFormat.parse(event.date); // Assuming `event.date` is in "dd-MM-yyyy" format
        event.status = determineEventStatus(eventDate); // Update status dynamically
        if(event.publish == 1){
          eventController.UpdateEventStatusPublic(event.id!, event.status);
        }
        else{
          eventController.UpdateEventStatus(event.id!, event.status);
        }
        return event;
      }).toList() ?? [];
      filteredEvents = events; // Initially, all events are displayed
    });

    fetchEventGifts(filteredEvents); // Fetch gifts for the updated events
  }

  void fetchEventGifts(List<Event> events) async{
    for (var event in events) {
      final gifts = await giftController.giftsList(event.id!);

      setState(() {
        event.gifts = gifts!;
      });
    }
  }

  String determineEventStatus(DateTime eventDate) {
    final DateTime now = DateTime.now();
    if (eventDate.isAfter(now)) {
      return 'Upcoming';
    }
    else if (eventDate.year == now.year &&
        eventDate.month == now.month &&
        eventDate.day == now.day) {
      return 'Current';
    }
    else {
      return 'Past';
    }
  }

  void sortEvents(String sortBy) {
    setState(() {
      this.sortBy = sortBy;
      filteredEvents.sort((a, b) {
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

  void searchEvents() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredEvents = events
          .where((event) => event.name.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Events List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.purpleAccent[700],
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search events by name',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: events.isEmpty?
              Center(
                child: Text(
                  'No Events yet. Add some!',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              )
                  :
              ListView.builder(
                itemCount: filteredEvents.length,
                itemBuilder: (context, index) {
                  final event = filteredEvents[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: event.status == "Past" ? const Color(0xFF9393FF) : const Color(0xABABFFFF),
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: ListTile(
                      title: Text(
                        event.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        '${event.category} • ${event.status}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      leading: IconButton(
                        onPressed: () async {
                          final bool? updatedEvent = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyEventDetails(event: event),
                            ),
                          );
                          if (updatedEvent == true) {
                            loadEvents(); //Load updated events
                          }
                        },
                        icon: const Icon(Icons.event),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Are you sure you want to delete the event permanently?"),
                                content: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          final String result = await eventController.DeleteEvent(event.name , event.id!);
                                          if (result == "${event.name} event has been deleted") {
                                            // Remove the event from the list and update the UI
                                            setState(() {
                                              events.removeAt(index);
                                              //This removes event according to name and id
                                              filteredEvents.removeWhere((e) => e.name == event.name && e.id == event.id);
                                            });
                                          }
                                          showMessage(context, result);
                                          Navigator.pop(context , true);
                                        },
                                        child: const Text("Delete"),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                MyGiftsPage(eventId: event.id!,eventName: event.name, eventStatus: event.status,),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(0.5, 0.0); // Slide in from the right
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;

                              var tween =
                              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );

                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to AddEventPage and wait for a result
          final bool? isEventAdded = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEventPage(),
            ),
          );
          // If a new event was added, refresh the list
          if (isEventAdded == true) {
            showMessage(context, "Event has been added successfully");
            loadEvents(); // Reload the events list
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
