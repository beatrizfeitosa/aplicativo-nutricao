import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:aplicativo_nutricao/data/database_helper.dart';

class DetalharAlimentoPage extends StatefulWidget {
  final String id;

  DetalharAlimentoPage({required this.id});

  @override
  _DetalharAlimentoPageState createState() => _DetalharAlimentoPageState();
}

class _DetalharAlimentoPageState extends State<DetalharAlimentoPage> {
  late Future<Map<String, dynamic>> _alimentoDetails;
  late Future<String> _nomeUsuario;

  @override
  void initState() {
    super.initState();
    _alimentoDetails = _getAlimentoDetails();
  }

  Future<Map<String, dynamic>> _getAlimentoDetails() async {
    try {
      print("Buscando detalhes do alimento com ID: ${widget.id}");
      var alimentos =
          await Database.retornaAlimentosPorId(int.parse(widget.id));
      if (alimentos.isEmpty) {
        throw Exception('Alimento não encontrado');
      }
      var alimento = alimentos.first;

      // Chamada para buscar o nome do usuário usando o userId
      _nomeUsuario = _getNomeUsuario(alimento['userId']);
      return alimento;
    } catch (e) {
      throw Exception('Erro ao carregar os detalhes: $e');
    }
  }

  Future<String> _getNomeUsuario(int userId) async {
    final detalhesUsuario =
        await Database.retornaDetalhesUsuario(userId.toString());
    return detalhesUsuario['nome'] ?? 'Usuário desconhecido';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Alimento'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _alimentoDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('Nenhum detalhe encontrado.'));
            } else {
              var alimento = snapshot.data!;
              return FutureBuilder<String>(
                future: _nomeUsuario,
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (userSnapshot.hasError) {
                    return Center(
                        child: Text('Erro ao carregar o nome do usuário.'));
                  } else {
                    var nomeUsuario =
                        userSnapshot.data ?? 'Usuário desconhecido';
                    return ListView(
                      children: [
                        // Foto do alimento
                        alimento['foto'] != null && alimento['foto'].isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.memory(
                                  Uint8List.fromList(alimento['foto']),
                                  width: double.infinity,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                height: 250,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(Icons.image,
                                    color: Colors.white, size: 80),
                              ),
                        SizedBox(height: 24),
                        // Informações do alimento
                        _buildInfoText('Nome', alimento['nome']),
                        _buildInfoText('Tipo', alimento['tipo']),
                        _buildInfoText('Categoria', alimento['categoria']),
                        _buildInfoText('Criado por', nomeUsuario),
                      ],
                    );
                  }
                },
              );
            }
          },
        ),
      ),
      backgroundColor: Color(0xFFE3ECF8),
    );
  }

  Widget _buildInfoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[800],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
