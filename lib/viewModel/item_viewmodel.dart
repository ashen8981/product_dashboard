import '../database/database_helper.dart';
import '../model/item_model.dart';
import 'package:flutter/material.dart';
import '../model/item_sale_model.dart';

class ItemViewModel extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Data for items and sales
  List<Item> _items = [];
  List<Item> get items => _items;

  List<ItemSale> _sales = [];
  List<ItemSale> get sales => _sales;

  double _netAmount = 0.0;
  double get netAmount => _netAmount;

  String? _selectedItem;
  String? get selectedItem => _selectedItem;

  // Fetch items from the database
  Future<void> fetchItems() async {
    _items = await _dbHelper.fetchItems();
    notifyListeners();
  }

  // Fetch sales from the database
  Future<void> fetchSales() async {
    _sales = await _dbHelper.fetchItemSales();
    _calculateNetAmount();
    notifyListeners();
  }

  // Add a new sale to the database
  Future<void> addSale(double price, int qty, double discount, String reason) async {
    if (_selectedItem == null) return;

    double amount = (price * qty) * (100 - discount) / 100;
    final sale = ItemSale(
      itemName: _selectedItem!,
      price: price,
      qty: qty,
      discount: discount,
      amount: amount,
      reason: reason,
    );

    await _dbHelper.insertItemSale(sale);
    await fetchSales();
  }

  // Select an item and notify listeners
  void selectItem(String? itemName) {
    _selectedItem = itemName;
    notifyListeners();
  }

  // Clear selected item
  void clearSelection() {
    _selectedItem = null;
    notifyListeners();
  }

  // Calculate total net amount
  void _calculateNetAmount() {
    _netAmount = _sales.fold(0.0, (total, sale) => total + sale.amount);
  }

  set selectedItem(String? value) {
    _selectedItem = value;
    notifyListeners();
  }

  bool validateForm(String qty) {
    // Validation for required fields
    if (_selectedItem == null || _selectedItem!.isEmpty) {
      return false; // Item must be selected
    }
    if (qty.isEmpty || double.tryParse(qty) == null) {
      return false; // Quantity must be a valid number
    }
    return true;
  }
}
