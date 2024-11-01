import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sql;

class Database {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        email TEXT NOT NULL,
        senha TEXT NOT NULL,
        nome TEXT,
        data_nascimento TEXT,
        foto BLOB,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);

    // Criação da tabela `alimentos`
    await database.execute("""
    CREATE TABLE alimentos (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  nome TEXT NOT NULL,
  categoria TEXT NOT NULL,
  tipo TEXT NOT NULL,
  foto BLOB,
  usuarioId INTEGER,
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
)
  """);
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase(
      'nutrify.db',
      version: 1,
      onConfigure: (database) async {},
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> insereUsuario(
      {required String email,
      required String senha,
      required String nome,
      required String dataNascimento,
      required List<int> foto}) async {
    final database = await Database.database();
    final data = {
      'email': email,
      'senha': senha,
      'nome': nome,
      'data_nascimento': dataNascimento,
      'foto': foto,
    };
    final id = await database.insert('usuarios', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<int> insereAlimento(
      {required String nome,
      required String categoria,
      required String tipo,
      required int usuarioId,
      required List<int> imageBytes}) async {
    final database = await Database.database();
    final data = {
      'nome': nome,
      'categoria': categoria,
      'tipo': tipo,
      'foto': imageBytes,
      'usuarioId': usuarioId,
    };
    final id = await database.insert('alimentos', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> retornaUsuario(String email) async {
    final database = await Database.database();
    return database.query('usuarios',
        where: "email = ?", whereArgs: [email], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> retornaUsuariosId() async {
    final database = await Database.database();
    return database.query('usuarios'); // Retorna todos os usuários
  }

  static Future<List<Map<String, dynamic>>> retornaUsuarios() async {
    final database = await Database.database();
    return database.query('usuarios');
  }

  static Future<List<Map<String, dynamic>>> retornaAlimentos() async {
    final database = await Database.database();
    return database.query('alimentos');
  }
}
