
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/Controller/Functions/ShowMessage.dart';
import 'package:hedieaty/Controller/GiftController.dart';
import 'package:hedieaty/Gifts/PledgedGift/PledgedGiftDetailsPage.dart';
import 'package:hedieaty/Model/Gift_Model.dart';

class PledgedGiftsPage extends StatefulWidget {
  const PledgedGiftsPage({super.key});

  @override
  State<PledgedGiftsPage> createState() => _PledgedGiftsPageState();
}

class _PledgedGiftsPageState extends State<PledgedGiftsPage> {
  final int currentUserID = FirebaseAuth.instance.currentUser!.uid.hashCode;
  TextEditingController searchController = TextEditingController();
  final GiftController giftController = GiftController();
  List<Gift> pledgedGifts = [];
  List<Gift> filteredPledgedGifts = [];
  String sortBy = "name";

  @override
  void initState() {
    super.initState();
    searchController.addListener(searchGifts);
    loadPledgedGifts();
  }

  Future<void> loadPledgedGifts() async {
    final fetchedGifts = await giftController.getUserPledgedGift(currentUserID);
    setState(() {
      pledgedGifts = fetchedGifts ?? [];
      filteredPledgedGifts = fetchedGifts ?? []; // Initially, all gifts are displayed
    });
  }


  void searchGifts() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredPledgedGifts = pledgedGifts
          .where((gift) => gift.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void sortGifts(String option) {
    setState(() {
      sortBy =  option;
      pledgedGifts.sort((a,b) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Pledged Gifts",
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
              child: filteredPledgedGifts.isEmpty?
              Center(
                child: Text(
                  'No Pledged Gifts yet. Add some!',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              )
                  :
              ListView.builder(
                itemCount: filteredPledgedGifts.length,
                itemBuilder: (context, index) {
                  final gift = filteredPledgedGifts[index];
                  bool isPledged = gift.status == "Pledged";
                  return Container(
                    decoration: BoxDecoration(
                      color: isPledged ? Colors.redAccent.withOpacity(0.4) : Colors.greenAccent.withOpacity(0.7),
                      border: Border.all(
                        color: isPledged ? Colors.red : Colors.green,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: ListTile(
                      title: Text(gift.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Category: ${gift.category}',
                            style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      trailing: isPledged
                          ? IconButton(
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
                                      final String result =
                                      await giftController.DeleteGift(
                                          gift.name, gift.id!);
                                      if (result ==
                                          "${gift.name} event has been deleted") {
                                        // Remove the gift from the list and update the UI
                                        setState(() {
                                          pledgedGifts.removeAt(index);
                                          filteredPledgedGifts.removeWhere((g) => g.name == gift.name && g.id == gift.id);
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
                      )
                          : null, // No delete icon for unpledged gifts
                        onTap: () async{
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PledgedGiftDetails(gift: gift),
                            ),
                          );
                          loadPledgedGifts(); // Reload the events list
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
