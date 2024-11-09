import 'package:flutter/material.dart';
import 'package:aplicativo_nutricao/data/database_helper.dart';

class BuscaController {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> resultados = [];
  bool _isLoading = false;

  // Callback para exibir mensagens de erro
  final Function(String)? showError;

  BuscaController({this.showError}) {
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() async {
    final termo = searchController.text.trim();

    if (_isLoading) return;

    if (termo.isNotEmpty) {
      _isLoading = true;
      try {
        resultados = await buscar(termo);
      } catch (e) {
        showError?.call('Erro ao buscar dados. Tente novamente.');
      } finally {
        _isLoading = false;
      }
    } else {
      resultados = [];
    }
  }

  Future<List<Map<String, dynamic>>> buscar(String termo) async {
    final resultados = await Database.buscaGeral(termo);
    return resultados.map((item) {
      return {
        'nome': item['nome'] as String?,
        'tipo': item['tipo'] as String,
        'foto': item['foto'] as List<int>?,
        'autor': item['autor'] as String?
      };
    }).toList();
  }

  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
  }

  bool get isLoading => _isLoading;
}
