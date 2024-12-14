
import 'package:flutter/material.dart';
import 'package:hedieaty/Gifts/PledgedGift/PledgedGiftDetailsPage.dart';
import 'package:hedieaty/Model/Gift_Model.dart';

class PledgedGiftsList extends StatelessWidget {
  final List<Gift> pledgedGifts;
  const PledgedGiftsList({super.key , required this.pledgedGifts});

  @override
  Widget build(BuildContext context) {
    return pledgedGifts.isEmpty?
    Center(
      child: Text(
        'No Pledged Gifts yet. Add some!',
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
      ),
    )
        :
    ListView.builder(
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
                fontSize: 18,
              ),),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Category: ${gift.category}',
                  style: TextStyle(
                    //fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),),
              ],
            ),
            trailing: isPledged
                ? IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {

              },
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
    );
  }
}
