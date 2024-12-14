
import 'package:flutter/material.dart';
import 'package:hedieaty/Gifts/MyGifts/MyGiftDetailsPage.dart';
import 'package:hedieaty/Model/Gift_Model.dart';

class MyGiftsList extends StatelessWidget {
  final List<Gift> gifts;
  const MyGiftsList({super.key , required this.gifts});

  @override
  Widget build(BuildContext context) {
    return gifts.isEmpty?
    Center(
      child: Text(
        'No Gifts yet. Add some!',
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
      ),
    )
        :
    ListView.builder(
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
                  onPressed: () {

                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    },
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
    );
  }
}
