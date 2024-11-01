import 'dart:io';
import 'package:aplicativo_nutricao/controllers/alimentos_controller.dart';
import 'package:flutter/material.dart';

class CadastroAlimento extends StatefulWidget {
  const CadastroAlimento({Key? key}) : super(key: key);

  @override
  State<CadastroAlimento> createState() => _CadastroAlimentoState();
}

class _CadastroAlimentoState extends State<CadastroAlimento> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  String? _categoriaSelecionada;
  String? _tipoSelecionado;
  String? _imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Alimento'),
      ),
      backgroundColor: const Color(0xFFE8FFD5),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _selectImage,
                    child: _imagePath != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: FileImage(File(_imagePath!)),
                          )
                        : const CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.camera_alt, color: Colors.white),
                          ),
                  ),
                  const SizedBox(height: 32),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Nome do Alimento',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      hintText: 'Digite o nome do alimento',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o nome do alimento';
                      }
                      return null;
                    },
                    maxLines: 1,
                  ),
                  const SizedBox(height: 25),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Selecione a Categoria',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ExpansionTile(
                        title: Text(
                          _categoriaSelecionada ?? 'Categoria',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        children: <Widget>[
                          const Divider(),
                          ListTile(
                            title: const Text('Café'),
                            onTap: () {
                              setState(() {
                                _categoriaSelecionada =
                                    'Café'; // Atualiza a categoria selecionada
                              });
                            },
                          ),
                          const Divider(),
                          ListTile(
                            title: const Text('Almoço'),
                            onTap: () {
                              setState(() {
                                _categoriaSelecionada =
                                    'Almoço'; // Atualiza a categoria selecionada
                              });
                            },
                          ),
                          const Divider(),
                          ListTile(
                            title: const Text('Janta'),
                            onTap: () {
                              setState(() {
                                _categoriaSelecionada =
                                    'Janta'; // Atualiza a categoria selecionada
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Selecione o Tipo',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ExpansionTile(
                        title: Text(
                          _tipoSelecionado ?? 'Tipo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        children: <Widget>[
                          const Divider(),
                          ListTile(
                            title: const Text('Bebida'),
                            onTap: () {
                              setState(() {
                                _tipoSelecionado =
                                    'Bebida'; // Atualiza a categoria selecionada
                              });
                            },
                          ),
                          const Divider(),
                          ListTile(
                            title: const Text('Proteina'),
                            onTap: () {
                              setState(() {
                                _tipoSelecionado =
                                    'Proteina'; // Atualiza a categoria selecionada
                              });
                            },
                          ),
                          const Divider(),
                          ListTile(
                            title: const Text('Carboidrato'),
                            onTap: () {
                              setState(() {
                                _tipoSelecionado =
                                    'Carboidrato'; // Atualiza a categoria selecionada
                              });
                            },
                          ),
                          const Divider(),
                          ListTile(
                            title: const Text('Fruta'),
                            onTap: () {
                              setState(() {
                                _tipoSelecionado =
                                    'Fruta'; // Atualiza a categoria selecionada
                              });
                            },
                          ),
                          const Divider(),
                          ListTile(
                            title: const Text('Grão'),
                            onTap: () {
                              setState(() {
                                _tipoSelecionado =
                                    'Grão'; // Atualiza a categoria selecionada
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      String? categoria = _categoriaSelecionada;
                      String? tipo = _tipoSelecionado;

                      //int usuarioId = 

                      if (_formKey.currentState!.validate()) {
                        if (categoria != null && tipo != null) {
                          AlimentosController().cadastrarAlimento(
                            nome: _nomeController.text,
                            categoria: categoria, // Passa a categoria selecionada
                            tipo: tipo, // Passa o tipo selecionado
                            foto: _imagePath, // Caminho da imagem
                            //usuarioId: usuario
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Selecione uma categoria e um tipo.')));
                        }
                        Navigator.pop(context); // Volta para a tela anterior
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFF46472), // Cor de fundo do botão
                      foregroundColor: Colors.white, // Cor do texto do botão
                      padding: const EdgeInsets.symmetric(
                          horizontal: 120, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cadastrar', // Texto do botão
                      style: TextStyle(
                        fontWeight: FontWeight.bold, // Deixa o texto em negrito
                        color: Colors
                            .white, // Garante que a cor do texto seja branca
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectImage() async {
    final path = await AlimentosController().selectImage();
    if (path != null) {
      setState(() {
        _imagePath = path;
      });
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }
}
