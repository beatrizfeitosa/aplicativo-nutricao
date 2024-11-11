import 'package:flutter/material.dart';
import 'package:aplicativo_nutricao/controllers/busca_controller.dart';
import 'package:aplicativo_nutricao/utils/format_date.dart';

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
    _usuarioDetails = _getUsuarioDetails();
  }

  Future<Map<String, dynamic>> _getUsuarioDetails() async {
    try {
      print("Buscando detalhes do usuário com ID: ${widget.id}");
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
        title: Text(
          'Detalhes do Usuário',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Título da AppBar em negrito
          ),
        ),
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
              String dataFormatada = formatarData(usuario['createdAt']);
              return ListView(
                children: [
                  // Foto do usuário
                  usuario['foto'] != null && usuario['foto'].isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.memory(
                            usuario['foto'],
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
                          child:
                              Icon(Icons.person, color: Colors.white, size: 80),
                        ),
                  SizedBox(height: 24),
                  // Informações do usuário
                  _buildInfoText('Nome', usuario['nome']),
                  _buildInfoText('Email', usuario['email']),
                  _buildInfoText(
                      'Data de Nascimento', usuario['data_nascimento']),
                  _buildInfoText('Data de Cadastro', dataFormatada),
                ],
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
