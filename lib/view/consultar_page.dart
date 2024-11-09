import 'package:flutter/material.dart';
import 'package:aplicativo_nutricao/controllers/busca_controller.dart'; // Importe o controller de busca
import 'dart:typed_data';

class ConsultaPage extends StatefulWidget {
  const ConsultaPage({super.key});

  @override
  State<ConsultaPage> createState() => _ConsultaPageState();
}

class _ConsultaPageState extends State<ConsultaPage> {
  final BuscaController _buscaController = BuscaController();

  @override
  void initState() {
    super.initState();
    _buscaController.searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "O que você procura hoje?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Você pode encontrar usuários, ou alimentos e cardápios criados por eles!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _buscaController.searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[300],
                hintText: "Digite para buscar...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_buscaController.isLoading)
              Center(child: CircularProgressIndicator()),
            if (!_buscaController.isLoading)
              Expanded(
                child: ListView.builder(
                  itemCount: _buscaController.resultados.length,
                  itemBuilder: (context, index) {
                    final item = _buscaController.resultados[index];
                    return _buildListItem(
                      title: item['nome'] ??
                          'Cardápio', // Gambiarra enquanto cardápio não tem o campo nome
                      subtitle: item['tipo'] ?? 'Desconhecido',
                      foto: item['foto'] != null
                          ? item['foto'] as List<int>
                          : null,
                      autor: item['autor'] ?? 'Sem autor',
                      tipo: item['tipo'] ?? 'Desconhecido',
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      backgroundColor: Color(0xFFE3ECF8),
    );
  }

  Widget _buildListItem({
    required String title,
    required String subtitle,
    required List<int>? foto,
    required String autor,
    required String tipo,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: foto != null && foto.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  Uint8List.fromList(foto),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              )
            : Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.image, color: Colors.white),
              ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          tipo == 'usuario' ? 'Usuário' : 'Autor: $autor',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Ação ao tocar no item
        },
      ),
    );
  }
}
