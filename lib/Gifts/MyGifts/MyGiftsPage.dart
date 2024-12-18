
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/Controller/Functions/ShowMessage.dart';
import 'package:hedieaty/Controller/GiftController.dart';
import 'package:hedieaty/Gifts/MyGifts/AddGiftsPage.dart';
import 'package:hedieaty/Gifts/MyGifts/MyGiftDetailsPage.dart';
import 'package:hedieaty/Model/Gift_Model.dart';

class MyGiftsPage extends StatefulWidget {
  final int eventId; // Pass the Event ID to associate the gift
  final String eventName;
  final String eventStatus;
  const MyGiftsPage({super.key, required this.eventId, required this.eventName, required this.eventStatus});


  @override
  State<MyGiftsPage> createState() => _MyGiftsPageState();
}

class _MyGiftsPageState extends State<MyGiftsPage> {
  final String currentUserID = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController searchController = TextEditingController();
  final GiftController giftController = GiftController();
  List<Gift> gifts = [];
  List<Gift> filteredGifts = [];
  late int EventId;
  late String EventName;
  late String EventStatus;
  String sortBy = "name"; // Default sort by name

  @override
  void initState() {
    super.initState();
    EventId = widget.eventId;
    EventName = widget.eventName;
    EventStatus = widget.eventStatus;
    searchController.addListener(searchGifts);
    loadGifts(); // Load gifts when the page is initialized
  }

  Future<void> loadGifts() async {
    final fetchedGifts = await giftController.giftsList(EventId);
    setState(() {
      gifts = fetchedGifts ?? [];
      filteredGifts = fetchedGifts ?? []; // Initially, all gifts are displayed
    });
  }

  Future<String?> getPledgedUserName(int giftId) async {
    try {
      return await giftController.getPledgedUserName(giftId);
    }
    catch (e) {
      print("Error fetching pledged user name: $e");
      return null; // Return null if there's an error
    }
  }

  void sortGifts(String option) {
    setState(() {
      sortBy = option;
      gifts.sort((a, b) {
        switch (option) {
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
      case 'Pledged':
        return 2;
      case 'Available':
        return 1;
      default:
        return 0;
    }
  }

  void searchGifts() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredGifts = gifts
          .where((gift) => gift.name.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${EventName}'s Gift List",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.purpleAccent[700],
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: sortGifts,
            itemBuilder: (context) => [
              const PopupMenuItem(value: "name", child: Text("Sort by Name")),
              const PopupMenuItem(value: "category", child: Text("Sort by Category")),
              const PopupMenuItem(value: "status", child: Text("Sort by Status")),
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
                  hintText: 'Search gifts by name',
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
              child: gifts.isEmpty
                  ? Center(
                child: Text(
                  'No Gifts yet. Add some!',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              )
                  : ListView.builder(
                itemCount: filteredGifts.length,
                itemBuilder: (context, index) {
                  final gift = filteredGifts[index];
                  bool isPledged = gift.status == "Pledged";

                  return FutureBuilder<String?>(
                    future: getPledgedUserName(gift.id!), // Fetch pledged user's name
                    builder: (context, snapshot) {
                      final pledgedName = snapshot.data ?? 'N/A';

                      return Container(
                        decoration: BoxDecoration(
                          color: !isPledged
                              ? Colors.greenAccent.withOpacity(0.7)
                              : Colors.redAccent.withOpacity(0.4),
                          border: Border.all(
                            color: isPledged ? Colors.red : Colors.green, // Red for pledged, green for unpledged
                            width: 2.0, // Adjust the width of the border as desired
                          ),
                          borderRadius: BorderRadius.circular(8.0), // Optional: add rounded corners
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        child: ListTile(
                          title: Text(
                            gift.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            "Category: ${gift.category} • Status: ${gift.status}",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          trailing: isPledged
                              ? Text(
                            pledgedName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          )
                              : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Are you sure you want to delete ${gift.name} permanently ?"),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              final String result = await giftController.DeleteGift(gift.name, gift.id!);

                                              if (result == "${gift.name} gift has been deleted") {
                                                setState(() {
                                                  gifts.removeWhere((g) => g.id == gift.id); // Remove from the main list
                                                  filteredGifts.removeWhere((g) => g.id == gift.id); // Remove from the filtered list
                                                });
                                              }

                                              showMessage(context, result);
                                              Navigator.pop(context, true);
                                            },
                                            child: const Text("Delete"),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Cancel")),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          onTap: () async {
                            bool? updatedGift = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyGiftDetails(gift: gift,),
                              ),
                            );

                            if (updatedGift == true) {
                              loadGifts();
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: EventStatus != "Past"
          ? FloatingActionButton(
        onPressed: () async {
          // Navigate to AddGiftPage and wait for a result
          final bool? isGiftAdded = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddGiftPage(
                eventId: EventId,
                eventName: EventName,
              ),
            ),
          );
          // If a new gift was added, refresh the list
          if (isGiftAdded == true) {
            showMessage(context, "Gift has been added successfully");
            loadGifts(); // Reload the gifts list
          }
        },
        child: const Icon(Icons.add),
      )
          : null ,
    );
  }
}