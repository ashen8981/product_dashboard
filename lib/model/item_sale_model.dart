class ItemSale {
  final String itemName;
  final double price;
  final int qty;
  final double discount;
  final double amount;
  final String? reason;

  ItemSale({
    required this.itemName,
    required this.price,
    required this.qty,
    required this.discount,
    required this.amount,
    this.reason,
  });

  Map<String, dynamic> toMap() {
    return {
      'item_name': itemName,
      'price': price,
      'qty': qty,
      'discount': discount,
      'amount': amount,
      'reason': reason,
    };
  }

  static ItemSale fromMap(Map<String, dynamic> map) {
    return ItemSale(
      itemName: map['item_name'],
      price: map['price'],
      qty: map['qty'],
      discount: map['discount'],
      amount: map['amount'],
      reason: map['reason'],
    );
  }
}
