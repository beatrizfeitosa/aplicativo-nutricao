import 'package:aplicativo_nutricao/view/cadastro_alimento.dart';
import 'package:aplicativo_nutricao/view/nsei.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; // Para usar a função join


class CadastroPage extends StatelessWidget {
  const CadastroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCCFFD1), // Cor de fundo verde claro
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 36, // Aumenta o tamanho do ícone
                          color: Colors.black,
                        ),
                        onPressed: () {
                          // Ação de voltar
                        },
                      ),
                      Positioned(
                        left:
                            2, // Desloca levemente para a direita para simular "bold"
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 36,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "O que você deseja cadastrar?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 295,
                child: ElevatedButton(
                  onPressed: () async {
                    cadastrarAlimento(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFF46472), // Cor de fundo do botão
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Novo Alimento",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 295,
                child: ElevatedButton(
                  onPressed: () {
                    consultarAlimento(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFF46472), // Cor de fundo do botão
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Novo Cardápio",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

   Future<void> deletarBancoDeDados() async {
    // Obter o caminho do banco de dados
    String caminhoBanco = join(await getDatabasesPath(), 'nutrify.db');
    await deleteDatabase(caminhoBanco); // Deletar o banco de dados
  }

  cadastrarAlimento(BuildContext context) async {
 // await deletarBancoDeDados();
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CadastroAlimento(),
    ),
  );
}

consultarAlimento(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AlimentosScreen(),
    ),
  );
}
}
