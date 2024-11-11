import 'package:flutter/material.dart';
import 'package:aplicativo_nutricao/controllers/busca_controller.dart';
import 'dart:typed_data';
import 'detalhe_usuario.dart';
import 'detalhe_alimento.dart';
import 'detalhe_cardapio.dart';

class ConsultaPage extends StatefulWidget {
  const ConsultaPage({super.key});

  @override
  State<ConsultaPage> createState() => _ConsultaPageState();
}

class _ConsultaPageState extends State<ConsultaPage> {
  late final BuscaController _buscaController;

  @override
  void initState() {
    super.initState();
    _buscaController = BuscaController(
      showError: (message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
    );
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "O que você procura hoje?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Você pode encontrar usuários, ou alimentos e cardápios criados por eles!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _buscaController.searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[300],
                hintText: "Digite para buscar...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListenableBuilder(
                listenable: _buscaController,
                builder: (context, _) {
                  if (_buscaController.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (_buscaController.resultados.isEmpty) {
                    return Center(
                      child: Text(
                        "Nenhum resultado encontrado.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: _buscaController.resultados.length,
                    itemBuilder: (context, index) {
                      final item = _buscaController.resultados[index];
                      return _buildListItem(
                        title: item['nome'] ??
                            'Cardápio', // Gambiarra enquanto cardápio não tem o campo nome
                        subtitle: item['tipo'] ?? 'Desconhecido',
                        foto: item['foto'] as List<int>?,
                        autor: item['autor'] ?? 'Sem autor',
                        tipo: item['tipo'] ?? 'Desconhecido',
                        id: item['id'] ?? '',
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFE3ECF8),
    );
  }

  Widget _buildListItem({
    required String title,
    required String subtitle,
    required List<int>? foto,
    required String autor,
    required String tipo,
    required String id,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: _buildLeadingImage(foto),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          tipo == 'usuario' ? 'Usuário' : 'Autor: $autor',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _handleItemTap(id, tipo),
      ),
    );
  }

  Widget _buildLeadingImage(List<int>? foto) {
    if (foto == null || foto.isEmpty) {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.image, color: Colors.white),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.memory(
        Uint8List.fromList(foto),
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.error, color: Colors.white),
          );
        },
      ),
    );
  }

  void _handleItemTap(String id, String tipo) {
    if (id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID inválido ou vazio')),
      );
      return;
    }

    switch (tipo) {
      case 'usuario':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalharUsuarioPage(id: id),
          ),
        );
        break;
      case 'alimento':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalharAlimentoPage(id: id),
          ),
        );
        break;
      case 'cardapio':
        final cardapioId = int.tryParse(id);
        if (cardapioId != null && cardapioId > 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DetalharCardapioPage(cardapioId: cardapioId),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ID do cardápio inválido')),
          );
        }
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tipo de item desconhecido')),
        );
    }
  }
}
