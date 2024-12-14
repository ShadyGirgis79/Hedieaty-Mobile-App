
import 'package:flutter/material.dart';
import 'package:hedieaty/Gifts/FriendGift/FriendsGiftDetailsPage.dart';
import 'package:hedieaty/Model/Gift_Model.dart';

class FriendGiftsList extends StatelessWidget {
  final List<Gift> gifts;
  const FriendGiftsList({super.key, required this.gifts});

  @override
  Widget build(BuildContext context) {
    return gifts.isEmpty?
    Center(
      child: Text(
        'No Gifts yet!',
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
              ),
            ),

            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FriendsGiftDetails(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
