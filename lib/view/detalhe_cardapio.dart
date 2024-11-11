import 'package:flutter/material.dart';
import 'package:aplicativo_nutricao/data/database_helper.dart';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:aplicativo_nutricao/utils/share.dart';
import 'dart:ui' as ui;

class DetalharCardapioPage extends StatefulWidget {
  final int cardapioId;

  DetalharCardapioPage({required this.cardapioId});

  @override
  _DetalharCardapioPageState createState() => _DetalharCardapioPageState();
}

class _DetalharCardapioPageState extends State<DetalharCardapioPage> {
  late Future<List<Map<String, dynamic>>> _alimentos;
  final ShareHelper _shareHelper = ShareHelper();
  final GlobalKey _shareKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _alimentos = Database.retornaCardapioAlimentos(widget.cardapioId);
  }

  Future<void> _shareDetailsAsImage() async {
    try {
      RenderRepaintBoundary boundary =
          _shareKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      _shareHelper.shareImage(pngBytes, "cardapio", "Detalhes do cardápio");
    } catch (e) {
      print("Erro ao capturar imagem: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3ECF8),
      appBar: AppBar(
        title: Text('Detalhes do Cardápio'),
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
      body: RepaintBoundary(
        key: _shareKey,
        child: Container(
          color: Color(0xFFE3ECF8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _alimentos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar os dados.'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text('Nenhum alimento encontrado para este cardápio.'));
                }

                final alimentos = snapshot.data!;

                return ListView.builder(
                  itemCount: alimentos.length,
                  itemBuilder: (context, index) {
                    final alimento = alimentos[index];
                    return _buildAlimentoItem(alimento);
                  },
                );
              },
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
        leading:
            // Foto do alimento
            alimento['foto'] != null && alimento['foto'].isNotEmpty
                ? Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
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
