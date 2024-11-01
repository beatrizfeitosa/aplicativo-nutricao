import 'package:flutter/material.dart';
import 'package:aplicativo_nutricao/data/database_helper.dart'; // Ajuste o caminho conforme necessário

class AlimentosScreen extends StatefulWidget {
  @override
  _AlimentosScreenState createState() => _AlimentosScreenState();
}

class _AlimentosScreenState extends State<AlimentosScreen> {
  List<Map<String, dynamic>> _alimentos = [];
  List<Map<String, dynamic>> _usuarios = [];
  bool _isLoading = false;

  Future<void> _carregarAlimentos() async {
    setState(() {
      _isLoading = true; // Inicia o carregamento
    });

    final alimentos = await Database.retornaAlimentos();
    setState(() {
      _alimentos = alimentos;
      _isLoading = false; // Finaliza o carregamento
    });

    final List<Map<String, dynamic>> usuarios = await Database.retornaUsuariosId();
setState(() {
  _usuarios = usuarios; // Aqui você está atribuindo a lista de mapas de usuários
  _isLoading = false; // Finaliza o carregamento
});


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Alimentos'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _carregarAlimentos,
              child: Text('Carregar Alimentos'),
            ),
            SizedBox(height: 20),
            _isLoading 
              ? CircularProgressIndicator() // Exibe um indicador de carregamento
              : Expanded(
                  child: ListView.builder(
                    itemCount: _alimentos.length,
                    itemBuilder: (context, index) {
                      final alimento = _alimentos[index];
                      final usuario = _usuarios[index];
                      return ListTile(
                        title: Text(alimento['nome'] ?? 'Nome não disponível''Categoria: ${alimento['categoria'] ?? 'Desconhecida'}' 'tipo: ${alimento['tipo'] ?? 'Desconhecida'}'),
                        subtitle: Text('id: ${alimento['usuarioId'] ?? 'SEM ID'}'),
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
