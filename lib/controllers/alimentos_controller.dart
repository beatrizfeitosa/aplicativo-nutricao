import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:aplicativo_nutricao/data/database_helper.dart';

class AlimentosController {
  Future<String?> selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image?.path;
  }

  Future<void> cadastrarAlimento({
    required String nome,
    required String tipo,
    required String categoria,
    String? foto,
    required int userId,
  }) async {
    List<int> imageBytes = [];
    if (foto != null) {
      imageBytes = await _converterImagemParaBytes(foto);
    }

    await Database.insereAlimento(nome:nome, tipo:tipo, categoria:categoria, foto: imageBytes, userId: userId);
  }

  Future<List<int>> _converterImagemParaBytes(String imagePath) async {
    final File imageFile = File(imagePath);
    return await imageFile.readAsBytes();
  }
}