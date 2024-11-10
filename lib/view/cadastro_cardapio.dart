import 'package:flutter/material.dart';
import 'package:aplicativo_nutricao/data/database_helper.dart';
import 'dart:typed_data';

class NovoCardapioPage extends StatefulWidget {
  const NovoCardapioPage({super.key});

  @override
  State<NovoCardapioPage> createState() => _NovoCardapioPageState();
}

class _NovoCardapioPageState extends State<NovoCardapioPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usuarioController = TextEditingController();

  List<Map<String, dynamic>> usuarios = [];
  List<Map<String, dynamic>> cafeOptions = [];
  List<Map<String, dynamic>> almocoOptions = [];
  List<Map<String, dynamic>> jantaOptions = [];

  int? selectedUsuarioId;
  List<int> selectedCafeIds = [];
  List<int> selectedAlmocoIds = [];
  List<int> selectedJantaIds = [];

  // Adicionando ScrollControllers
  final ScrollController _usuarioScrollController = ScrollController();
  final ScrollController _cafeScrollController = ScrollController();
  final ScrollController _almocoScrollController = ScrollController();
  final ScrollController _jantaScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    usuarios = await Database.retornaIdsENomesUsuarios();
    cafeOptions = await Database.retornaAlimentosPorCategoria('Café');
    almocoOptions = await Database.retornaAlimentosPorCategoria('Almoço');
    jantaOptions = await Database.retornaAlimentosPorCategoria('Janta');
    setState(() {});
  }

  @override
  void dispose() {
    // Disposing ScrollControllers
    _usuarioScrollController.dispose();
    _cafeScrollController.dispose();
    _almocoScrollController.dispose();
    _jantaScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8FFD5),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 40, 10),
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
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                      child: Column(
                        children: [
                          const Text(
                            'Novo cardápio',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildUsuarioDropdown(),
                          const SizedBox(height: 16),
                          _buildExpansionTile(
                            title: 'Opções para o café',
                            options: cafeOptions,
                            selectedOptions: selectedCafeIds,
                            maxSelection: 3,
                            scrollController: _cafeScrollController,
                          ),
                          const SizedBox(height: 16),
                          _buildExpansionTile(
                            title: 'Opções para o almoço',
                            options: almocoOptions,
                            selectedOptions: selectedAlmocoIds,
                            maxSelection: 5,
                            scrollController: _almocoScrollController,
                          ),
                          const SizedBox(height: 16),
                          _buildExpansionTile(
                            title: 'Opções para a janta',
                            options: jantaOptions,
                            selectedOptions: selectedJantaIds,
                            maxSelection: 4,
                            scrollController: _jantaScrollController,
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.maxFinite,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (selectedUsuarioId != null &&
                                      selectedCafeIds.isNotEmpty &&
                                      selectedAlmocoIds.isNotEmpty &&
                                      selectedJantaIds.isNotEmpty) {
                                    try {
                                      await Database.insereCardapio(
                                        userId: selectedUsuarioId!,
                                        alimentosCafe: selectedCafeIds,
                                        alimentosAlmoco: selectedAlmocoIds,
                                        alimentosJanta: selectedJantaIds,
                                      );

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Cardápio cadastrado com sucesso!"),
                                        ),
                                      );

                                      setState(() {
                                        selectedUsuarioId = null;
                                        selectedCafeIds.clear();
                                        selectedAlmocoIds.clear();
                                        selectedJantaIds.clear();
                                      });
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Erro ao cadastrar cardápio: $e"),
                                        ),
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Por favor, selecione o usuário e todas as opções de alimentos."),
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF46472),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Cadastrar',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildUsuarioDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nome do Usuário',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () => _showUsuarioDropdown(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(selectedUsuarioId == null
                    ? 'Selecione um usuário'
                    : usuarios.firstWhere((usuario) =>
                        usuario['id'] == selectedUsuarioId)['nome']),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showUsuarioDropdown() {
    String searchQuery = '';

    List<Map<String, dynamic>> _filteredUsuarios() {
      if (searchQuery.isEmpty) {
        return usuarios;
      } else {
        return usuarios.where((usuario) {
          return usuario['nome']
              .toLowerCase()
              .contains(searchQuery.toLowerCase());
        }).toList();
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final filteredUsuarios = _filteredUsuarios();
            return AlertDialog(
              title: const Text('Selecione um usuário'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Buscar usuário',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Scrollbar(
                        thumbVisibility: true,
                        thickness: 6.0,
                        radius: const Radius.circular(8),
                        scrollbarOrientation: ScrollbarOrientation.right,
                        controller: _usuarioScrollController,
                        child: filteredUsuarios.isEmpty
                            ? Center(
                                child: Text(
                                  'Nenhum usuário encontrado.',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : ListView(
                                controller: _usuarioScrollController,
                                children: filteredUsuarios.map((usuario) {
                                  return ListTile(
                                    title: Text(usuario['nome']),
                                    onTap: () {
                                      setState(() {
                                        selectedUsuarioId = usuario['id'];
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  );
                                }).toList(),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildExpansionTile({
    required String title,
    required List<Map<String, dynamic>> options,
    required List<int> selectedOptions,
    required int maxSelection,
    required ScrollController scrollController,
  }) {
    TextEditingController searchController = TextEditingController();
    List<Map<String, dynamic>> filteredOptions = List.from(options);

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        void filterOptions(String query) {
          setState(() {
            filteredOptions = options.where((option) {
              return option['nome'].toLowerCase().contains(query.toLowerCase());
            }).toList();
          });
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: ExpansionTile(
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.black),
                    hintText: 'Buscar alimento...',
                    border: const UnderlineInputBorder(),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black,
                          width: 2), // Cor e espessura da linha quando focado
                    ),
                  ),
                  onChanged: filterOptions,
                ),
              ),
              SizedBox(
                height: 200,
                child: Scrollbar(
                  thumbVisibility: true,
                  thickness: 6.0,
                  radius: Radius.circular(8),
                  scrollbarOrientation: ScrollbarOrientation.right,
                  controller: scrollController,
                  child: filteredOptions.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Nenhum alimento encontrado.',
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            children: filteredOptions.map((option) {
                              final bool isSelected =
                                  selectedOptions.contains(option['id']);
                              final List<int> imageBytes =
                                  List<int>.from(option['foto']);
                              return CheckboxListTile(
                                title: Text(option['nome']),
                                subtitle: Text(option['tipo']),
                                secondary: (imageBytes.isNotEmpty)
                                    ? Image.memory(
                                        Uint8List.fromList(imageBytes),
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      )
                                    : Icon(
                                        Icons.image_not_supported,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                activeColor: const Color(0xFFF46472),
                                value: isSelected,
                                onChanged: (bool? selected) {
                                  setState(() {
                                    if (selected == true) {
                                      if (selectedOptions.length <
                                          maxSelection) {
                                        selectedOptions.add(option['id']);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Você pode selecionar no máximo $maxSelection opções para '$title'.",
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
                                      selectedOptions.remove(option['id']);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}