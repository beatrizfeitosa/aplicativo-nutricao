import 'package:aplicativo_nutricao/context/user_context.dart';
import 'package:flutter/material.dart';
import 'package:aplicativo_nutricao/data/database_helper.dart';
import 'package:aplicativo_nutricao/view/login_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print(await Database.retornaUsuarios());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
