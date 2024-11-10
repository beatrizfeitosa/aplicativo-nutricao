import 'package:flutter/material.dart';
import 'package:aplicativo_nutricao/controllers/busca_controller.dart'; // Importe o controller

class DetalharUsuarioPage extends StatefulWidget {
  final String id;

  DetalharUsuarioPage({required this.id});

  @override
  _DetalharUsuarioPageState createState() => _DetalharUsuarioPageState();
}

class _DetalharUsuarioPageState extends State<DetalharUsuarioPage> {
  late Future<Map<String, dynamic>> _usuarioDetails;

  @override
  void initState() {
    super.initState();
    // Inicializa a consulta para pegar os dados do usuário
    _usuarioDetails = _getUsuarioDetails();
  }

  Future<Map<String, dynamic>> _getUsuarioDetails() async {
    try {
      print(
          "Buscando detalhes do usuário com ID: ${widget.id}"); // Verificar ID recebido
      var usuario = await BuscaController().buscaDetalhesUsuario(widget.id);
      if (usuario == null) {
        throw Exception('Usuário não encontrado');
      }
      return usuario;
    } catch (e) {
      throw Exception('Erro ao carregar os detalhes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _usuarioDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('Nenhum detalhe encontrado.'));
            } else {
              var usuario = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nome: ${usuario['nome']}',
                      style: TextStyle(fontSize: 18)),
                  Text('Email: ${usuario['email']}',
                      style: TextStyle(fontSize: 18)),
                  Text('Data de Nascimento: ${usuario['data_nascimento']}',
                      style: TextStyle(fontSize: 18)),
                  Text('Data de Cadastro: ${usuario['createdAt']}',
                      style: TextStyle(fontSize: 18)),
                  // Outras informações adicionais, como alimentos e cardápios
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
