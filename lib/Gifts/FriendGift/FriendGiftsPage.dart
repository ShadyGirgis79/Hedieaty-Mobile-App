
import 'package:flutter/material.dart';
import 'package:hedieaty/Gifts/FriendGift/FriendGiftsList.dart';
import 'package:hedieaty/Model/Gift_Model.dart';

class FriendGiftsPage extends StatefulWidget {
  const FriendGiftsPage({super.key});

  @override
  State<FriendGiftsPage> createState() => _FriendGiftsPageState();
}

class _FriendGiftsPageState extends State<FriendGiftsPage> {
  TextEditingController searchController = TextEditingController();
  List<Gift> gifts = [];
  List<Gift> filteredGifts = [];

  String sortBy = "name"; // Default sort by name

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
    double price = 0;

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
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Category"),
                  value: category.isEmpty ? null : category, // Set value to null if category is empty
                  onChanged: (String? newValue) {
                    setState(() {
                      category = newValue!;
                    });
                  },
                  items: <String>[
                    'Electronics', 'Books', 'Toys', 'Souvenir', 'Accessories', 'Other'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number, // Ensure keyboard is numeric
                  onChanged: (value) {
                    price = double.tryParse(value) ?? 0; // Safely convert to int
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
              const SizedBox(height: 10),
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
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Are you sure you want to delete?"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    gifts.remove(gift);
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

  void searchGifts(String query) {
    setState(() {
      filteredGifts = gifts.where((event) {
        return event.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Gift List",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),),
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
              child: FriendGiftsList(gifts: filteredGifts),
            ),
          ],
        ),
      ),
    );
  }
}
