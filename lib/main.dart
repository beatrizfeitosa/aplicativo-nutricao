import 'package:flutter/material.dart';
import 'package:aplicativo_nutricao/data/database_helper.dart';
import 'package:aplicativo_nutricao/view/LoginPage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  print(await Database.retornaUsuarios());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
    );
  }
}
