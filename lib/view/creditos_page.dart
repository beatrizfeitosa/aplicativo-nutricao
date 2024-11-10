import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreditosPage extends StatefulWidget {
  const CreditosPage({super.key});

  @override
  State<CreditosPage> createState() => _CreditosPageState();
}

class _CreditosPageState extends State<CreditosPage> {
  final List<Map<String, String>> _desenvolvedores = [
    {
      'nome': 'Beatriz Feitosa',
      'descricao': 'Protótipo e Tela de Consulta',
      'imagem': 'assets/images/Bia.jpg',
    },
    {
      'nome': 'Denner Willian',
      'descricao': 'Tela de Cadastro de Alimentos e Cardápio',
      'imagem': 'assets/images/Denner.png',
    },
    {
      'nome': 'Hercules Correa',
      'descricao': 'Tela de Cadastro de Alimentos e Cardápio',
      'imagem': 'assets/images/Hercules.png',
    },
    {
      'nome': 'Jefferson Monteiro',
      'descricao': 'Tela Principal e Créditos',
      'imagem': 'assets/images/jeff.png',
    },
    {
      'nome': 'Raphael Willian',
      'descricao': 'Tela de Login e Cadastro de Usuário',
      'imagem': 'assets/images/raphael.jpeg',
    },
    {
      'nome': 'Victor Akahane',
      'descricao': 'Protótipo e Tela de Consulta',
      'imagem': 'assets/images/Aka.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 236, 213, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Créditos',
              style: GoogleFonts.inter(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Conheça todos os desenvolvedores do aplicativo.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _desenvolvedores.length,
                itemBuilder: (context, index) {
                  final desenvolvedor = _desenvolvedores[index];
                  return _buildCreditItem(
                    nome: desenvolvedor['nome']!,
                    descricao: desenvolvedor['descricao']!,
                    imagemPath: desenvolvedor['imagem']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditItem({
    required String nome,
    required String descricao,
    required String imagemPath,
  }) {
    return Card(
      color: const Color.fromARGB(255, 243, 229, 208), // Cor bege claro
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 5,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imagemPath,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          nome,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          descricao,
          style: TextStyle(
            color: const Color.fromARGB(255, 65, 65, 65),
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
