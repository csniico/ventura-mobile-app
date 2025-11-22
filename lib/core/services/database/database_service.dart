import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ventura/core/models/business/business.dart';
import 'package:ventura/core/models/customer/customer.dart';
import 'package:ventura/core/models/invoice/invoice.dart';
import 'package:ventura/core/models/user/user.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._internal();

  static final String usersTable = "users";

  factory DatabaseService() => instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await init();
    return _db!;
  }

  Future<Database> init() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(
      databasePath,
      version: 2, // Version updated to 2
      onCreate: (db, version) async {
        await db.execute("""
          CREATE TABLE IF NOT EXISTS users (
            id TEXT PRIMARY KEY,
            firstName TEXT,
            lastName TEXT,
            email TEXT,
            avatarUrl TEXT,
            googleId TEXT,
            businessId TEXT,
            isSystem INTEGER,
            isActive INTEGER DEFAULT 0
          );
        """);

        await db.execute("""
          CREATE TABLE IF NOT EXISTS businesses (
            id TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            email TEXT,
            phone TEXT,
            website TEXT,
            logo TEXT,
            address TEXT,
            city TEXT,
            state TEXT,
            country TEXT,
            zipCode TEXT,
            ownerId TEXT,
            isActive INTEGER
          );
        """);

        await db.execute("""
          CREATE TABLE IF NOT EXISTS customers (
            id TEXT PRIMARY KEY,
            firstName TEXT,
            lastName TEXT,
            email TEXT,
            phone TEXT,
            avatar TEXT,
            address TEXT,
            city TEXT,
            state TEXT,
            country TEXT,
            zipCode TEXT,
            businessId TEXT,
            isActive INTEGER
          );
        """);

        await db.execute("""
          CREATE TABLE IF NOT EXISTS invoices (
            id TEXT PRIMARY KEY,
            invoiceNumber TEXT,
            status TEXT,
            issueDate TEXT,
            dueDate TEXT,
            subtotal REAL,
            tax REAL,
            discount REAL,
            total REAL,
            amountPaid REAL,
            amountDue REAL,
            notes TEXT,
            terms TEXT,
            paymentMethod TEXT,
            businessId TEXT,
            customerId TEXT
          );
        """);

        await db.execute("""
          CREATE TABLE IF NOT EXISTS invoice_items (
            id TEXT PRIMARY KEY,
            invoiceId TEXT,
            description TEXT,
            quantity REAL,
            unitPrice REAL,
            total REAL
          );
        """);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // This runs when the version number is increased.
        if (oldVersion < 2) {
          await db.execute(
            "ALTER TABLE users ADD COLUMN isActive INTEGER DEFAULT 0",
          );
        }
      },
    );
    return database;
  }

  // USER CRUD OPERATIONS
  Future<void> saveUser(User user) async {
    final db = await database;
    await db.insert(
      "users",
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUser() async {
    final db = await database;
    final res = await db.query("users", where: "isActive = ?", whereArgs: [1]);

    if (res.length > 1) {
      // Inconsistent state, more than one active user.
      // Deactivate all users and return null.
      await db.update("users", {"isActive": 0});
      return null;
    }

    if (res.isEmpty) return null;
    return User.fromMap(res.first);
  }

  Future<void> signIn(String userId) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.update("users", {"isActive": 0});
      await txn.update(
        "users",
        {"isActive": 1},
        where: "id = ?",
        whereArgs: [userId],
      );
    });
  }

  Future<void> signOut(String userId) async {
    final db = await database;
    await db.update(
      "users",
      {"isActive": 0},
      where: "id = ?",
      whereArgs: [userId],
    );
  }

  Future<void> deleteUser() async {
    final db = await database;
    await db.delete("users");
  }

  // ---------------------------------------------------
  // BUSINESS CRUD
  // ---------------------------------------------------

  Future<void> saveBusiness(Business business) async {
    final db = await database;
    await db.insert(
      "businesses",
      business.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Business>> getBusinesses() async {
    final db = await database;
    final res = await db.query("businesses");
    return res.map((e) => Business.fromMap(e)).toList();
  }

  Future<void> deleteBusiness(String id) async {
    final db = await database;
    await db.delete("businesses", where: "id = ?", whereArgs: [id]);
  }

  // ---------------------------------------------------
  // CUSTOMER CRUD
  // ---------------------------------------------------

  Future<void> saveCustomer(Customer customer) async {
    final db = await database;
    await db.insert(
      "customers",
      customer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Customer>> getCustomers(String businessId) async {
    final db = await database;
    final res = await db.query(
      "customers",
      where: "businessId = ?",
      whereArgs: [businessId],
    );
    return res.map((e) => Customer.fromMap(e)).toList();
  }

  Future<void> deleteCustomer(String id) async {
    final db = await database;
    await db.delete("customers", where: "id = ?", whereArgs: [id]);
  }

  // ---------------------------------------------------
  // INVOICE CRUD
  // ---------------------------------------------------

  Future<void> saveInvoice(Invoice invoice) async {
    final db = await database;

    // Save invoice
    await db.insert(
      "invoices",
      invoice.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Save invoice items
    for (var item in invoice.items ?? []) {
      await db.insert(
        "invoice_items",
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Invoice>> getInvoices(String businessId) async {
    final db = await database;

    final res = await db.query(
      "invoices",
      where: "businessId = ?",
      whereArgs: [businessId],
    );

    // Load items for each invoice
    List<Invoice> list = [];
    for (var row in res) {
      final invoice = Invoice.fromMap(row);

      final items = await db.query(
        "invoice_items",
        where: "invoiceId = ?",
        whereArgs: [invoice.id],
      );

      invoice.items = items.map((e) => InvoiceItem.fromMap(e)).toList();
      list.add(invoice);
    }

    return list;
  }

  Future<void> deleteInvoice(String id) async {
    final db = await database;
    await db.delete("invoice_items", where: "invoiceId = ?", whereArgs: [id]);
    await db.delete("invoices", where: "id = ?", whereArgs: [id]);
  }
}
