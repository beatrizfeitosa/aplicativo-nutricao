import 'package:sqflite/sqflite.dart' as sql;

class Database {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        senha TEXT NOT NULL,
        nome TEXT NOT NULL,
        data_nascimento TEXT NOT NULL,
        foto BLOB,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);

    await database.execute("""
    CREATE TABLE alimentos (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      nome TEXT NOT NULL,
      categoria TEXT NOT NULL,
      tipo TEXT NOT NULL,
      foto BLOB,
      userId INTEGER NOT NULL,
      createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (userId) REFERENCES usuarios(id)
    )
    """);

    await database.execute("""
    CREATE TABLE cardapios (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      userId INTEGER NOT NULL,
      createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (userId) REFERENCES usuarios(id)
    )
    """);

    await database.execute("""
      CREATE TABLE cardapios_alimentos (
        cardapio_id INTEGER NOT NULL,
        alimento_id INTEGER NOT NULL,
        PRIMARY KEY (cardapio_id, alimento_id),
        FOREIGN KEY (cardapio_id) REFERENCES cardapios(id) ON DELETE CASCADE,
        FOREIGN KEY (alimento_id) REFERENCES alimentos(id) ON DELETE CASCADE
      )
    """);
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase(
      'nutrify.db',
      version: 1,
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
      required String tipo,
      required String categoria,
      required List<int> foto,
      required int userId}) async {
    final database = await Database.database();
    final data = {
      'nome': nome,
      'categoria': categoria,
      'tipo': tipo,
      'foto': foto,
      'userId': userId,
    };
    final id = await database.insert('alimentos', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<int> insereCardapio({
    required int userId,
    required List<int> alimentosCafe,
    required List<int> alimentosAlmoco,
    required List<int> alimentosJanta,
  }) async {
    final database = await Database.database();

    return await database.transaction((txn) async {
      final cardapioId = await txn.insert(
        'cardapios',
        {'userId': userId},
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );

      Future<void> inserirAlimentos(List<int> alimentos) async {
        for (int alimentoId in alimentos) {
          await txn.insert(
            'cardapios_alimentos',
            {
              'cardapio_id': cardapioId,
              'alimento_id': alimentoId,
            },
            conflictAlgorithm: sql.ConflictAlgorithm.replace,
          );
        }
      }

      await inserirAlimentos(alimentosCafe);
      await inserirAlimentos(alimentosAlmoco);
      await inserirAlimentos(alimentosJanta);

      return cardapioId;
    });
  }

  static Future<List<Map<String, dynamic>>> retornaUsuario(String email) async {
    final database = await Database.database();
    return database.query('usuarios',
        where: "email = ?", whereArgs: [email], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> retornaUsuarios() async {
    final database = await Database.database();
    return database.query('usuarios');
  }

  static Future<List<Map<String, dynamic>>> retornaIdsENomesUsuarios() async {
    final database = await Database.database();

    final List<Map<String, dynamic>> usuarios = await database.query(
      'usuarios',
      columns: ['id', 'nome'],
    );

    return usuarios;
  }

  static Future<List<Map<String, dynamic>>> retornaAlimentos() async {
    final database = await Database.database();
    return database.query('alimentos');
  }

  static Future<List<Map<String, dynamic>>> retornaAlimentosPorId(
      int id) async {
    final database = await Database.database();

    final List<Map<String, dynamic>> alimento = await database.query(
      'alimentos',
      columns: ['id', 'nome', 'tipo', 'categoria', 'foto', 'userId'],
      where: 'id = ?',
      whereArgs: [id],
    );

    return alimento;
  }

  static Future<List<Map<String, dynamic>>> retornaAlimentosPorCategoria(
      String categoria) async {
    final database = await Database.database();

    final List<Map<String, dynamic>> alimentos = await database.query(
      'alimentos',
      columns: ['id', 'nome', 'tipo', 'foto'],
      where: 'categoria = ?',
      whereArgs: [categoria],
      orderBy: 'nome ASC',
    );

    return alimentos;
  }

  // Retorna detalhes de um cardápio específico pelo ID
  static Future<List<Map<String, dynamic>>> retornaCardapio(
      int cardapioId) async {
    final database = await Database.database();
    return database.query(
      'cardapios',
      where: 'id = ?',
      whereArgs: [cardapioId],
      limit: 1,
    );
  }

  // Retorna alimentos associados a um cardápio específico
  static Future<List<Map<String, dynamic>>> retornaCardapioAlimentos(
      int cardapioId) async {
    final database = await Database.database();

    // Fazendo uma consulta usando JOIN para pegar os alimentos associados ao cardápio
    final List<Map<String, dynamic>> alimentos = await database.rawQuery("""
      SELECT a.id, a.nome, a.categoria, a.tipo 
      FROM cardapios_alimentos ca
      JOIN alimentos a ON ca.alimento_id = a.id
      WHERE ca.cardapio_id = ?
    """, [cardapioId]);

    return alimentos;
  }

  static Future<Map<String, dynamic>> retornaDetalhesUsuario(String id) async {
    final database = await Database.database();

    // Buscando o usuário com o ID específico
    final List<Map<String, dynamic>> result = await database.query(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first; // Retorna o mapa com os dados do usuário
    } else {
      throw Exception('Usuário não encontrado');
    }
  }

  static Future<List<Map<String, dynamic>>> buscaGeral(String termo) async {
    final database = await Database.database();
    final termoLower = '%${termo.toLowerCase()}%';

    final result = await database.rawQuery('''
    SELECT 'usuario' AS tipo, id, nome, NULL AS categoria, NULL AS tipo_alimento, NULL AS userId, foto, NULL AS autor
    FROM usuarios
    WHERE LOWER(nome) LIKE ?

    UNION ALL

    SELECT 'alimento' AS tipo, a.id, a.nome, a.categoria, a.tipo AS tipo_alimento, a.userId, a.foto, u.nome AS autor
    FROM alimentos a
    JOIN usuarios u ON u.id = a.userId
    WHERE LOWER(a.nome) LIKE ? OR LOWER(a.categoria) LIKE ? OR a.userId IN (
      SELECT id FROM usuarios WHERE LOWER(nome) LIKE ?
    )

    UNION ALL

    SELECT DISTINCT 'cardapio' AS tipo, c.id, NULL AS nome, NULL AS categoria, NULL AS tipo_alimento, c.userId, NULL AS foto, u.nome AS autor
    FROM cardapios c
    JOIN usuarios u ON u.id = c.userId
    LEFT JOIN cardapios_alimentos ca ON ca.cardapio_id = c.id
    LEFT JOIN alimentos a ON a.id = ca.alimento_id
    WHERE LOWER(u.nome) LIKE ? OR LOWER(a.nome) LIKE ?
  ''', [
      termoLower,
      termoLower,
      termoLower,
      termoLower,
      termoLower,
      termoLower,
    ]);

    return result;
  }
}
