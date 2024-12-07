class Item {
  final int id;
  final String itemName;
  final double price;

  Item({required this.id, required this.itemName, required this.price});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item_name': itemName,
      'price': price,
    };
  }

  static Item fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      itemName: map['item_name'],
      price: map['price'],
    );
  }
}
