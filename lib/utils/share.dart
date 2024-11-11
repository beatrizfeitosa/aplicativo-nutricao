import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ShareHelper {
  Future<void> shareImage(Uint8List imageBytes, String nomeImagem, String descricao) async {
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/$nomeImagem.png').create();
    await file.writeAsBytes(imageBytes);

    Share.shareXFiles([XFile(file.path)], text: descricao);
  }
}
