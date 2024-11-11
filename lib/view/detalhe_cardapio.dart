import 'package:flutter/material.dart';
import 'package:aplicativo_nutricao/data/database_helper.dart';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:aplicativo_nutricao/utils/share.dart';
import 'dart:ui' as ui;

class DetalharCardapioPage extends StatefulWidget {
  final int cardapioId;

  const DetalharCardapioPage({super.key, required this.cardapioId});

  @override
  DetalharCardapioPageState createState() => DetalharCardapioPageState();
}

class DetalharCardapioPageState extends State<DetalharCardapioPage> {
  late Future<List<Map<String, dynamic>>> _alimentos;
  final ShareHelper _shareHelper = ShareHelper();
  final GlobalKey _shareKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _alimentos = Database.retornaCardapioAlimentos(widget.cardapioId);
  }

  Future<void> _calculateHeight() async {
    await Future.delayed(Duration(milliseconds: 300));
    setState(() {
    });
  }

  Future<void> _shareDetailsAsImage() async {
    try {
      await _calculateHeight();

      RenderRepaintBoundary boundary =
          _shareKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      _shareHelper.shareImage(pngBytes, "cardapio", "Detalhes do cardápio");
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao compartilhar cardapio: $e"),
        ),
      );
    }
  }

  Map<String, List<Map<String, dynamic>>> _organizeByCategory(
      List<Map<String, dynamic>> alimentos) {
    final Map<String, List<Map<String, dynamic>>> groupedAlimentos = {};
    for (var alimento in alimentos) {
      final String categoria =
          alimento['categoria'] ?? 'Categoria desconhecida';
      if (!groupedAlimentos.containsKey(categoria)) {
        groupedAlimentos[categoria] = [];
      }
      groupedAlimentos[categoria]!.add(alimento);
    }

    final orderedCategories = ['Café', 'Almoço', 'Janta'];
    final Map<String, List<Map<String, dynamic>>> sortedGroupedAlimentos = {};

    for (var category in orderedCategories) {
      if (groupedAlimentos.containsKey(category)) {
        sortedGroupedAlimentos[category] = groupedAlimentos[category]!;
      }
    }

    groupedAlimentos.forEach((key, value) {
      if (!orderedCategories.contains(key)) {
        sortedGroupedAlimentos[key] = value;
      }
    });

    return sortedGroupedAlimentos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3ECF8),
      appBar: AppBar(
        title: Text(
          'Detalhes do Cardápio',
          style: TextStyle(
            fontWeight: FontWeight.bold,
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
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.black),
            onPressed: () => _shareDetailsAsImage(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: RepaintBoundary(
          key: _shareKey,
          child: Container(
            color: Color(0xFFE3ECF8),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Cardápio',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _alimentos,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text('Erro ao carregar os dados.'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text(
                                'Nenhum alimento encontrado para este cardápio.'));
                      }

                      final groupedAlimentos =
                          _organizeByCategory(snapshot.data!);

                      return Column(
                        children: groupedAlimentos.entries.map((entry) {
                          final categoria = entry.key;
                          final alimentos = entry.value;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0, bottom: 8.0),
                                child: Text(
                                  categoria,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ...alimentos
                                  .map((alimento) =>
                                      _buildAlimentoItem(alimento)),
                            ],
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlimentoItem(Map<String, dynamic> alimento) {
    final String nome = alimento['nome'] ?? 'Nome desconhecido';
    final String categoria = alimento['categoria'] ?? 'Categoria desconhecida';
    final String tipo = alimento['tipo'] ?? 'Tipo desconhecido';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: alimento['foto'] != null && alimento['foto'].isNotEmpty
            ? Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                width: 50,
                height: 50,
                child: Image.memory(
                  Uint8List.fromList(alimento['foto']),
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
        title: Text(nome, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Categoria: $categoria',
                style: TextStyle(color: Colors.grey[600])),
            Text('Tipo: $tipo', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
