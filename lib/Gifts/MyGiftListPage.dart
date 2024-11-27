import 'package:flutter/material.dart';
import 'package:hedieaty/Details/MyGiftDetailsPage.dart';
import 'package:hedieaty/Model/Gift_Model.dart';

class MyGiftList extends StatefulWidget {
  const MyGiftList({super.key});

  @override
  State<MyGiftList> createState() => _MyGiftListState();
}

class _MyGiftListState extends State<MyGiftList> {
  List<Gift> gifts = [
    Gift(name: "Teddy Bear", category: "Toy", status: "Pledged" , price:100),
    Gift(name: "Phone", category: "Electronics", status: "Unpledged", price:24000),
    Gift(name: "Watch", category: "Electronics", status: "Unpledged", price:8500),
    Gift(name: "Harry Potter", category: "Books", status: "Pledged", price:70),
    Gift(name: "Bracelet", category: "Accessories", status: "Pledged", price:350),
  ];

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
                    price = int.tryParse(value) ?? 0; // Safely convert to int
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
              title: Text(gift.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),),
              subtitle: Text("Category: ${gift.category} • Status: ${gift.status}",
                style: TextStyle(
                  //fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),),
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
                  : const Text("Name",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),), // No trailing icons if the item is pledged
              //Here I want to add name of the person that will get gift
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyGiftDetails(),
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
