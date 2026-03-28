import 'package:pdf_reader/data/models/pdf_file_model.dart';
import 'package:sqflite/sqflite.dart';
import "package:path/path.dart" as p;

class SqlService {
  SqlService._();
  static final SqlService instance = SqlService._();

  static const String _dbName = 'app_database.db';
  static const int _dbVersion = 1;

  static const String table = 'pdf_file_paths';

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _openDb();
    return _db!;
  }

  Future<Database> _openDb() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await _createSchema(db);
      },
      onUpgrade: (db, oldVersion, newVersion) {},
    );
  }

  Future<void> _createSchema(Database db) => db.execute('''
      CREATE TABLE IF NOT EXISTS $table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        path TEXT NOT NULL,
        name TEXT NOT NULL
      );''');

  Future<void> createPdfFile(Map<String, String> data) async {
    final db = await database;
    await db.insert(table, data);
  }

  Future<void> insertPdfFile(PdfFileModel pdfFile) async {
    final db = await database;
    await db.insert(table, pdfFile.toJson());
  }

  Future<List<PdfFileModel>> getAllPdfFiles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return maps.map((e) => PdfFileModel.fromJson(e)).toList();
  }
}
