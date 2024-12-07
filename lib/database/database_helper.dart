import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path_package;
import '../model/item_model.dart';
import '../model/item_sale_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = path_package.join(await getDatabasesPath(), 'item_details.db');
    return await openDatabase(
      dbPath,
      version: 2, // Updated version
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Item_Details(
        id INTEGER PRIMARY KEY,
        item_name TEXT NOT NULL,
        price REAL NOT NULL
      )
    ''');

    // Preload data
    await db.insert('Item_Details', {'id': 1, 'item_name': 'Item 1', 'price': 50.00});
    await db.insert('Item_Details', {'id': 2, 'item_name': 'Item 2', 'price': 60.00});
    await db.insert('Item_Details', {'id': 3, 'item_name': 'Item 3', 'price': 70.00});

    await db.execute('''
      CREATE TABLE Item_Sales(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_name TEXT NOT NULL,
        price REAL NOT NULL,
        qty INTEGER NOT NULL,
        discount REAL NOT NULL,
        amount REAL NOT NULL,
        reason TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE Item_Sales(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          item_name TEXT NOT NULL,
          price REAL NOT NULL,
          qty INTEGER NOT NULL,
          discount REAL NOT NULL,
          amount REAL NOT NULL,
          reason TEXT
        )
      ''');
    }
  }

  // Fetch saved sales data from the database
  Future<List<ItemSale>> fetchItemSales() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Item_Sales');

    return List.generate(
      maps.length,
      (i) => ItemSale(
        itemName: maps[i]['item_name'],
        price: maps[i]['price'],
        qty: maps[i]['qty'],
        discount: maps[i]['discount'],
        amount: maps[i]['amount'],
        reason: maps[i]['reason'],
      ),
    );
  }

  // Insert item sale data into the database
  Future<void> insertItemSale(ItemSale sale) async {
    final db = await database;
    await db.insert(
      'Item_Sales',
      sale.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Item>> fetchItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Item_Details');
    print("Fetched Items: $maps");
    return List.generate(
      maps.length,
      (i) => Item(
        id: maps[i]['id'],
        itemName: maps[i]['item_name'],
        price: maps[i]['price'],
      ),
    );
  }

  Future<void> insertItem(Item item) async {
    final db = await database;
    await db.insert(
      'Item_Details',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
