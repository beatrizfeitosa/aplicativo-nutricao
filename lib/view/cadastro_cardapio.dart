import 'package:flutter/material.dart';
import 'package:aplicativo_nutricao/data/database_helper.dart';

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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Carregar dados do banco de dados
    usuarios = await Database.retornaIdsENomesUsuarios();
    cafeOptions = await Database.retornaAlimentosPorCategoria('Café');
    almocoOptions = await Database.retornaAlimentosPorCategoria('Almoço');
    jantaOptions = await Database.retornaAlimentosPorCategoria('Janta');
    setState(() {});
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
                          ),
                          const SizedBox(height: 16),
                          _buildExpansionTile(
                            title: 'Opções para o almoço',
                            options: almocoOptions,
                            selectedOptions: selectedAlmocoIds,
                            maxSelection: 5,
                          ),
                          const SizedBox(height: 16),
                          _buildExpansionTile(
                            title: 'Opções para a janta',
                            options: jantaOptions,
                            selectedOptions: selectedJantaIds,
                            maxSelection: 4,
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: 300,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (selectedUsuarioId != null &&
                                      selectedCafeIds.isNotEmpty &&
                                      selectedAlmocoIds.isNotEmpty &&
                                      selectedJantaIds.isNotEmpty) {
                                    try {
                                        final cardapioId = await Database.insereCardapio(
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

                                      print(await Database.retornaCardapio(cardapioId));
                                      print(await Database.retornaCardapioAlimentos(cardapioId));

                                      // Limpar as seleções após cadastrar
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Selecione um usuário'),
          content: SizedBox(
            width: double.maxFinite,
            child: Scrollbar(
              thumbVisibility: true,
              thickness: 6.0,
              radius: const Radius.circular(8),
              scrollbarOrientation: ScrollbarOrientation.right,
              child: ListView(
                children: usuarios.map((usuario) {
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
        );
      },
    );
  }

  Widget _buildExpansionTile({
    required String title,
    required List<Map<String, dynamic>> options,
    required List<int> selectedOptions,
    required int maxSelection,
  }) {
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
          SizedBox(
            height: 150,
            child: Scrollbar(
              thumbVisibility: true,
              thickness: 6.0,
              radius: Radius.circular(8),
              scrollbarOrientation: ScrollbarOrientation.right,
              child: SingleChildScrollView(
                child: Column(
                  children: options.map((option) {
                    final bool isSelected =
                        selectedOptions.contains(option['id']);
                    return CheckboxListTile(
                      title: Text(option['nome']),
                      activeColor: const Color(0xFFF46472),
                      value: isSelected,
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected == true) {
                            if (selectedOptions.length < maxSelection) {
                              selectedOptions.add(option['id']);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
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
  }
}