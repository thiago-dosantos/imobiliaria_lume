import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  factory DbHelper() => _instance;
  DbHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String pathBanco = join(await getDatabasesPath(), 'imobiliaria.db');

    return await openDatabase(
      pathBanco,
      version: 1,
      onCreate: (db, version) {
        return db.execute("""
          CREATE TABLE imoveis(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT,
            descricao TEXT,
            valor REAL,
            tipo TEXT,
            negocio TEXT,
            fotoPath TEXT
          )
        """);
      },
    );
  }
}