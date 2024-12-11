

class Gift {
  String name;
  String category;
  String status; // Pledged or Unpledged
  String description;
  String imageURL;
  double price;


  Gift({
    required this.name,
    required this.category,
    required this.status,
    this.description="",
    this.imageURL="",
    required this.price});
}
