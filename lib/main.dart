import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aplicativo_nutricao/context/user_context.dart';
import 'package:aplicativo_nutricao/view/login_page.dart';
import 'package:aplicativo_nutricao/view/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('userId');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MyApp(userId: userId),
    ),
  );
}

class MyApp extends StatelessWidget {
  final int? userId;

  const MyApp({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: userId == null ? const LoginPage() : const HomePage(),
    );
  }
}
