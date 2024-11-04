import 'dart:io';
import 'package:aplicativo_nutricao/context/user_context.dart';
import 'package:aplicativo_nutricao/controllers/alimentos_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CadastroAlimento extends StatefulWidget {
  const CadastroAlimento({super.key});

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
    final userProviderId = Provider.of<UserProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: const Color(0xFFE8FFD5),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 0),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 36,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Text(
                        "Novo alimento",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
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
                      'Nome',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _nomeController,
                    decoration: InputDecoration(
                      hintText: 'Digite o nome do alimento',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1000),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: const TextStyle(
                      fontSize: 14,
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
                      'Categoria',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ExpansionTile(
                        title: Text(
                          _categoriaSelecionada ?? 'Café, almoço, janta...',
                          style: TextStyle(
                            fontSize: 14,
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
                      'Tipo',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ExpansionTile(
                        title: Text(
                          _tipoSelecionado ?? 'Bebida, fruta, grão...',
                          style: TextStyle(
                            fontSize: 14,
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
                    onPressed: () async {
                      String? categoria = _categoriaSelecionada;
                      String? tipo = _tipoSelecionado;

                      if (_formKey.currentState!.validate()) {
                        if (categoria != null && tipo != null) {
                          await AlimentosController().cadastrarAlimento(
                            nome: _nomeController.text,
                            tipo: tipo,
                            categoria: categoria,
                            foto: _imagePath,
                            userId: userProviderId.userId!,
                          );

                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Selecione uma categoria e um tipo.'),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF46472),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 120, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cadastrar', // Texto do botão
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
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