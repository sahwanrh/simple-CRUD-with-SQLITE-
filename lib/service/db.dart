import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'your_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Create your tables here
        await db.execute('''
          CREATE TABLE table1 (
            id INTEGER PRIMARY KEY,
            nama TEXT,
            tanggalLahir TEXT,
            idPekerjaan TEXT,
            Status INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE table2 (
            id INTEGER PRIMARY KEY,
            pekerjaan TEXT,
            status TEXT
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> leftOuterJoinExample() async {
    final Database db = await database;

    // Perform a left outer join between table1 and table2
    // You can adjust the ON condition based on your specific tables
    String query = '''
      SELECT A.id, A.nama,A.tanggalLahir,A.idPekerjaan,A.Status
      FROM table1 A
      LEFT OUTER JOIN table2 ON table2 B = A.idPekerjaan = B.ID
    ''';

    return await db.rawQuery(query);
  }
}
