import 'package:flutter/material.dart';

class DetalharCardapioPage extends StatelessWidget {
  final String id;

  DetalharCardapioPage({required this.id});

  @override
  Widget build(BuildContext context) {
    // Aqui você faria uma consulta no banco de dados ou serviço para pegar os dados do cardápio
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Cardápio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detalhes do cardápio com ID: $id',
                style: TextStyle(fontSize: 20)),
            // Exibir mais informações sobre o cardápio
            // Por exemplo, nome, descrição, itens que ele contém, etc.
          ],
        ),
      ),
    );
  }
}
