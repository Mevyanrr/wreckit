import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wreckit/main_feature/models/scanner_model.dart';
import 'package:wreckit/scan_result/models/scanresult_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('qrisk_history.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE history (
        id TEXT PRIMARY KEY,
        url TEXT NOT NULL,
        verdict TEXT NOT NULL,
        risk_score INTEGER NOT NULL,
        scanned_at TEXT NOT NULL
      )
    ''');
  }

  // Save scan result to SQLite
  Future<void> insertScan(ScanResultModel result) async {
    final db = await instance.database;
    await db.insert(
      'history',
      {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'url': result.url,
        'verdict': result.status.name.toUpperCase(), // AMAN, WASPADA, BAHAYA
        'risk_score': result.riskScore,
        'scanned_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all local history entries
  Future<List<ScanHistoryItem>> getLocalHistory() async {
    final db = await instance.database;
    final maps = await db.query('history', orderBy: 'scanned_at DESC');

    return maps.map((json) {
      return ScanHistoryItem.fromBackendMap({
        'id': json['id'],
        'scanned_url': json['url'],
        'verdict': json['verdict'],
        'risk_score': json['risk_score'],
        'created_at': json['scanned_at'],
      });
    }).toList();
  }
}