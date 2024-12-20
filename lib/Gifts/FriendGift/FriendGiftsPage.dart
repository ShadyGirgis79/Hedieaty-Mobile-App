
import 'package:flutter/material.dart';
import 'package:hedieaty/Controller/GiftController.dart';
import 'package:hedieaty/Gifts/FriendGift/FriendsGiftDetailsPage.dart';
import 'package:hedieaty/Model/Gift_Model.dart';

class FriendGiftsPage extends StatefulWidget {
  final int eventId; // Pass the Event ID to associate the gift
  final String eventName;
  final int friendId;
  const FriendGiftsPage({super.key, required this.eventId, required this.eventName, required this.friendId});

  @override
  State<FriendGiftsPage> createState() => _FriendGiftsPageState();
}

class _FriendGiftsPageState extends State<FriendGiftsPage> {
  TextEditingController searchController = TextEditingController();
  final GiftController giftController = GiftController();
  List<Gift> gifts = [];
  List<Gift> filteredGifts = [];
  late int EventId;
  late String EventName;
  late int FriendID;
  String sortBy = "name"; // Default sort by name

  @override
  void initState() {
    super.initState();
    EventId = widget.eventId;
    EventName = widget.eventName;
    FriendID = widget.friendId;
    searchController.addListener(searchGifts);
    loadGifts(); // Load events when the page is initialized
  }

  Future<void> loadGifts() async {
    final fetchedGifts = await giftController.friendGiftsList(EventId);
    setState(() {
      gifts = fetchedGifts ?? [];
      filteredGifts = fetchedGifts ?? []; // Initially, all events are displayed
    });
  }

  void sortGifts(String option) {
    setState(() {
      sortBy =  option;
      gifts.sort((a,b) {
        switch(option){
          case 'name':
            return a.name.compareTo(b.name);
          case 'category':
            return a.category.compareTo(b.category);
          case 'status':
            return statusPriority(a.status).compareTo(statusPriority(b.status));
          default :
            return 0;
        }
      });
    });
  }

  int statusPriority(String status){
    switch(status){
      case 'Pledged':
        return 2;
      case 'Available':
        return 1;
      default :
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
        title: Text("${EventName} Gift List",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),),
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
              child: filteredGifts.isEmpty?
              Center(
                child: Text(
                  'No Gifts yet!',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              )
                  :
              ListView.builder(
                itemCount: filteredGifts.length,
                itemBuilder: (context, index) {
                  final gift = filteredGifts[index];
                  bool isPledged = gift.status == "Pledged";

                  return Container(
                    decoration: BoxDecoration(
                      color: !isPledged ? Colors.greenAccent.withOpacity(0.7) : Colors.redAccent.withOpacity(0.4),
                      border: Border.all(
                        color: isPledged ? Colors.red : Colors.green, // Red for pledged, green for unpledged
                        width: 2.0, // Adjust the width of the border as desired
                      ),
                      borderRadius: BorderRadius.circular(8.0), // Optional: add rounded corners
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: ListTile(
                      title: Text(gift.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),),
                      subtitle: Text("Category: ${gift.category} • Status: ${gift.status}",
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      onTap: () async{
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FriendsGiftDetails(gift: gift, eventName: EventName, friendId: FriendID,),
                          ),
                        );
                          loadGifts(); // Reload the events list
                        }
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
