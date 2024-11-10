import 'package:flutter/material.dart';
import 'package:aplicativo_nutricao/data/database_helper.dart';
import 'dart:typed_data';

class DetalharCardapioPage extends StatefulWidget {
  final int cardapioId; // Alterando para int, já que seu id parece ser numérico

  DetalharCardapioPage({required this.cardapioId});

  @override
  _DetalharCardapioPageState createState() => _DetalharCardapioPageState();
}

class _DetalharCardapioPageState extends State<DetalharCardapioPage> {
  late Future<List<Map<String, dynamic>>> _alimentos;

  @override
  void initState() {
    super.initState();
    // Usando a função existente para buscar os alimentos associados ao cardápio
    _alimentos = Database.retornaCardapioAlimentos(widget.cardapioId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Cardápio'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _alimentos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os dados.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('Nenhum alimento encontrado para este cardápio.'));
          }

          final alimentos = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: alimentos.length,
              itemBuilder: (context, index) {
                final alimento = alimentos[index];
                return _buildAlimentoItem(alimento);
              },
            ),
          );
        },
      ),
    );
  }

  // Widget para exibir cada alimento com suas informações
  Widget _buildAlimentoItem(Map<String, dynamic> alimento) {
    final String nome = alimento['nome'] ?? 'Nome desconhecido';
    final String categoria = alimento['categoria'] ?? 'Categoria desconhecida';
    final String tipo = alimento['tipo'] ?? 'Tipo desconhecido';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.food_bank, size: 50, color: Colors.green),
        title: Text(nome, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Categoria: $categoria',
                style: TextStyle(color: Colors.grey[600])),
            Text('Tipo: $tipo', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
