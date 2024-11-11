import 'package:flutter/material.dart';
import 'package:aplicativo_nutricao/data/database_helper.dart';
import 'dart:async';

class BuscaController extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> resultados = [];
  bool _isLoading = false;
  Timer? _debounceTimer;
  final Function(String)? showError;
  String _lastSearchTerm = '';

  BuscaController({this.showError}) {
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final termo = searchController.text.trim();

      if (termo == _lastSearchTerm) {
        return;
      }

      if (_isLoading) return;

      if (termo.isNotEmpty) {
        _setLoading(true);

        try {
          resultados = await buscar(termo);
          _lastSearchTerm = termo;
          notifyListeners();
        } catch (e) {
          showError?.call('Erro ao buscar dados. Tente novamente.');
        } finally {
          _setLoading(false);
        }
      } else {
        if (_lastSearchTerm.isNotEmpty) {
          resultados = [];
          _lastSearchTerm = '';
          notifyListeners();
        }
      }
    });
  }

  Future<List<Map<String, dynamic>>> buscar(String termo) async {
    final resultados = await Database.buscaGeral(termo);
    return resultados.map((item) {
      return {
        'id': item['id'].toString(),
        'nome': item['nome'] as String?,
        'tipo': item['tipo'] as String,
        'foto': item['foto'] as List<int>?,
        'autor': item['autor'] as String?,
      };
    }).toList();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  bool get isLoading => _isLoading;

  Future<Map<String, dynamic>> buscaDetalhesUsuario(String id) async {
    final resultado = await Database.retornaDetalhesUsuario(id);
    return resultado;
  }
}
