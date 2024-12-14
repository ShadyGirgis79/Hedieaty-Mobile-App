
import 'package:flutter/material.dart';
import 'package:hedieaty/Controller/EventController.dart';
import 'package:hedieaty/Model/Event_Model.dart';
import 'package:hedieaty/MyEvents/MyEventDetailsPage.dart';
import '../Controller/ShowMessage.dart';
import '../Gifts/MyGiftListPage.dart';

class EventsList extends StatelessWidget {
  final List<Event> events;
  EventsList({super.key, required this.events});

  final EventController eventController = EventController();

  @override
  Widget build(BuildContext context) {
    return events.isEmpty?
    Center(
      child: Text(
        'No Events yet. Add some!',
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
      ),
    )
        :
    ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
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
                final updatedEvent = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyEventDetails(event: event),
                  ),
                );
                if (updatedEvent != null) {
                  events[index] = updatedEvent;
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
                      title: const Text("Are you sure you want to delete event?"),
                      content: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                final String result = await eventController.DeleteEvent(event.name);
                                showMessage(context, result);
                                Navigator.pop(context , true);
                              },
                              child: const Text("Yes"),
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
            onTap: () {
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
    );
  }
}
