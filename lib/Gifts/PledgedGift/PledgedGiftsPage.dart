
import 'package:flutter/material.dart';
import 'package:hedieaty/Gifts/PledgedGift/PledgedGiftsList.dart';
import 'package:hedieaty/Model/Gift_Model.dart';

class PledgedGiftsPage extends StatefulWidget {
  const PledgedGiftsPage({super.key});

  @override
  State<PledgedGiftsPage> createState() => _PledgedGiftsPageState();
}

class _PledgedGiftsPageState extends State<PledgedGiftsPage> {

  TextEditingController searchController = TextEditingController();
  List<Gift> pledgedGifts = [];
  List<Gift> filteredPledgedGifts = [];

  void removeUnpledgedGifts() {
    setState(() {
      pledgedGifts.removeWhere((gift) => gift.status == "Unpledged");
    });
  }

  @override
  void initState() {
    super.initState();
    // Automatically remove unpledged gifts when the page loads
    removeUnpledgedGifts();
  }


  void searchGifts(String query) {
    setState(() {
      filteredPledgedGifts = pledgedGifts.where((event) {
        return event.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pledged Gifts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),),
        foregroundColor: Colors.white,
        backgroundColor: Colors.purpleAccent[700],
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
              child: PledgedGiftsList(pledgedGifts: filteredPledgedGifts),
            ),
          ],
        ),
      ),
    );
  }
}
