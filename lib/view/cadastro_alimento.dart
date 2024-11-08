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
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 36,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Novo alimento",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                  _buildTextField('Nome', _nomeController, 'Digite o nome do alimento'),
                  const SizedBox(height: 25),
                  _buildDropdownField(
                    'Categoria',
                    _categoriaSelecionada,
                    ['Café', 'Almoço', 'Janta'],
                    (value) => setState(() => _categoriaSelecionada = value),
                  ),
                  const SizedBox(height: 25),
                  _buildDropdownField(
                    'Tipo',
                    _tipoSelecionado,
                    ['Bebida', 'Proteina', 'Carboidrato', 'Fruta', 'Grão', 'Doce', 'Legume', 'Verdura', 'Outros'],
                    (value) => setState(() => _tipoSelecionado = value),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_categoriaSelecionada != null && _tipoSelecionado != null) {
                          await AlimentosController().cadastrarAlimento(
                            nome: _nomeController.text,
                            tipo: _tipoSelecionado!,
                            categoria: _categoriaSelecionada!,
                            foto: _imagePath,
                            userId: userProviderId.userId!,
                          );

                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Selecione uma categoria e um tipo.'),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF46472),
                      padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cadastrar',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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

  Widget _buildTextField(String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    String? selectedValue,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: selectedValue,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          hint: Text('Selecione $label'),
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          validator: (value) =>
              value == null || value.isEmpty ? 'Selecione uma $label' : null,
        ),
      ],
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
