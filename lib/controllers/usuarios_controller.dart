import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:crypto/crypto.dart';
import 'package:aplicativo_nutricao/data/database_helper.dart';

class UsuariosController {
  Future<String?> selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image?.path;
  }

  Future<void> cadastrarUsuario({
    required String nome,
    required String dataNascimento,
    required String email,
    required String senha,
    String? imagePath,
  }) async {
    final usuarioExistente = await Database.retornaUsuario(email);
    if (usuarioExistente.isNotEmpty) {
      throw Exception('Email já cadastrado');
    }

    String senhaHash = _calcularHash(senha);

    List<int> imageBytes = [];
    if (imagePath != null) {
      imageBytes = await _converterImagemParaBytes(imagePath);
    }

    await Database.insereUsuario(nome:nome, dataNascimento:dataNascimento, email:email, senha:senhaHash, foto: imageBytes);
  }

  String _calcularHash(String password) {
    var passwordInBytes = utf8.encode(password);
    return sha256.convert(passwordInBytes).toString();
  }

  Future<List<int>> _converterImagemParaBytes(String imagePath) async {
    final File imageFile = File(imagePath);
    return await imageFile.readAsBytes();
  }
}
