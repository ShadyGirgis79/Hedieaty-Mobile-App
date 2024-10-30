import 'package:flutter/material.dart';
import 'package:hedieaty/GiftDetailsPage.dart';

class Gift {
  String name;
  String category;
  String status; // Pledged or Unpledged
  int price;

Gift({required this.name, required this.category , required this.status ,required this.price});
}

class GiftListPage extends StatefulWidget {
  const GiftListPage({super.key});

  @override
  State<GiftListPage> createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  List<Gift> gifts = [
    Gift(name: "Teddy Bear", category: "Toy", status: "Pledged" , price:100),
    Gift(name: "Phone", category: "Electronics", status: "Unpledged", price:24000),
    Gift(name: "Watch", category: "Electronics", status: "Unpledged", price:8500),
    Gift(name: "Harry Potter", category: "Books", status: "Pledged", price:70),
  ];

  String sortBy = "name"; // Default sort by name

  void sortGifts(String option) {
    setState(() {
      this.sortBy =  option;
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
      case 'Unpledged':
        return 1;
      default :
        return 0;
    }
  }

  void addGift() {
    String name = "";
    String category ="";
    String status = "Unpledged";
    int price = 0;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Add Gift"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: (value){
                    name = value;
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(labelText: 'Category'),
                  onChanged: (value){
                    category = value;
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(labelText: 'Price'),
                  onChanged: (value){
                    price = value as int;
                  },
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: (){
                    if(name.isNotEmpty && category.isNotEmpty) {
                      setState(() {
                        gifts.add(Gift(name: name, category: category, status: status ,price: price));
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add')
              ),
            ],
          );
        }
    );
  }

  void editGift(Gift gift) {
    // Temporary variables to hold new values for the event.
    String updatedName = gift.name;
    String updatedCategory = gift.category;
    String updatedStatus = gift.status;

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
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Category"),
                  value: updatedCategory,
                  onChanged: (String? newValue) {
                    updatedCategory = newValue!;
                  },
                  items: <String>['Electronics', 'Books', 'Toys', 'Souvenir','Accessories','Other']
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
                    gift.name = updatedName;
                    gift.category = updatedCategory;
                    gift.status = updatedStatus;
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

  void deleteGift(Gift gift) {
    setState(() {
      gifts.remove(gift);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gift List"),
        backgroundColor: Colors.purpleAccent,
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
      body: ListView.builder(
        itemCount: gifts.length,
        itemBuilder: (context, index) {
          final gift = gifts[index];
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
              title: Text(gift.name),
              subtitle: Text("Category: ${gift.category} • Status: ${gift.status}"),
              //This is made to remove icons if Gift is pledged
              trailing: !isPledged
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => editGift(gift),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteGift(gift),
                  ),
                ],
              )
                  : null, // No trailing icons if the item is pledged
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
      floatingActionButton: FloatingActionButton(
        onPressed: addGift,
        //backgroundColor: Colors.purpleAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
