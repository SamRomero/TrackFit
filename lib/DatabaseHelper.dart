import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static late Database _database;

  DatabaseHelper.internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase() async {
    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, 'trackfit_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE registros (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user INTEGER,
            name TEXT,
            location INTEGER,
            deporte INTEGER,
            is_actividad INTEGER,
            categoria INTEGER,
            duracion INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertRegistro(Map<String, dynamic> registro) async {
    final db = await database;
    return await db.insert('registros', registro);
  }

  Future<List<Map<String, dynamic>>> getAllRegistros() async {
    final db = await database;
    return await db.query('registros');
  }
}