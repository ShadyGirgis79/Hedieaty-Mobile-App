
import 'package:flutter/material.dart';
import 'package:hedieaty/Details/PledgedGiftDetailsPage.dart';
import 'package:hedieaty/Model/Gift_Model.dart';

class PLedgedGiftsPage extends StatefulWidget {
  const PLedgedGiftsPage({super.key});

  @override
  State<PLedgedGiftsPage> createState() => _PLedgedGiftsPageState();
}

class _PLedgedGiftsPageState extends State<PLedgedGiftsPage> {
  List<Gift> pledgedGifts = [
    Gift(name: "Teddy Bear", category: "Toy", status: "Pledged" , price:100),
    Gift(name: "Phone", category: "Electronics", status: "Unpledged", price:24000),
    Gift(name: "Watch", category: "Electronics", status: "Unpledged", price:8500),
    Gift(name: "Harry Potter", category: "Books", status: "Pledged", price:70),
    Gift(name: "Bracelet", category: "Accessories", status: "Pledged", price:350),
  ];

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

  void deleteGift(Gift gift) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Are you sure you want to delete?"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    pledgedGifts.remove(gift);
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
        title: const Text('My Pledged Gifts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),),
        foregroundColor: Colors.white,
        backgroundColor: Colors.purpleAccent,
      ),
      body: ListView.builder(
        itemCount: pledgedGifts.length,
        itemBuilder: (context, index) {
          final gift = pledgedGifts[index];
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
                  fontSize: 20,
                ),),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Category: ${gift.category}',
                    style: TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),),
                ],
              ),
              trailing: isPledged
                  ? IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => deleteGift(gift),
              )
                  : null, // No delete icon for unpledged gifts
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PledgedGiftDetails(),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

