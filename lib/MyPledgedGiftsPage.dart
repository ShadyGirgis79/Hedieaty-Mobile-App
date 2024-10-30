import 'package:flutter/material.dart';
import 'package:hedieaty/GiftDetailsPage.dart';

class GiftFriend {
  String name;
  String friendName;
  String category;
  String status;
  DateTime dueDate;

  GiftFriend({
    required this.name,
    required this.friendName,
    required this.dueDate,
    required this.category,
    required this.status,
  });
}

class MyPledgedGiftsPage extends StatefulWidget {
  const MyPledgedGiftsPage({super.key});

  @override
  State<MyPledgedGiftsPage> createState() => _MyPledgedGiftsPageState();
}

class _MyPledgedGiftsPageState extends State<MyPledgedGiftsPage> {
  List<GiftFriend> pledgedGifts = [
    GiftFriend(name: 'Book', friendName: 'Harry Potter', dueDate: DateTime(2024, 12, 15), category: "Books", status: "Pledged"),
    GiftFriend(name: 'Headphones', friendName: 'Bob', dueDate: DateTime(2024, 11, 20), category: "Electronics", status: "Pledged"),
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

  void deleteGift(GiftFriend gift) {
    setState(() {
      pledgedGifts.remove(gift);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pledged Gifts'),
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
              title: Text(gift.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Friend: ${gift.friendName}'),
                  Text('Category: ${gift.category}'),
                  Text('Due Date: ${gift.dueDate.toLocal().toShortDateString()}'),
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
                    builder: (context) => const GiftDetailsPage(),
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

extension on DateTime {
  String toShortDateString() {
    return '${this.day}-${this.month}-${this.year}';
  }
}
