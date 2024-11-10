import 'package:flutter/material.dart';

class DetalharAlimentoPage extends StatelessWidget {
  final String id;

  DetalharAlimentoPage({required this.id});

  @override
  Widget build(BuildContext context) {
    // Aqui você faria uma consulta no banco de dados ou serviço para pegar os dados do alimento
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Alimento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detalhes do alimento com ID: $id',
                style: TextStyle(fontSize: 20)),
            // Exibir mais informações sobre o alimento
            // Por exemplo, nome, calorias, ingredientes, etc.
          ],
        ),
      ),
    );
  }
}
