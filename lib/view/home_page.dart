import 'package:flutter/material.dart';
import 'package:aplicativo_nutricao/view/consultar_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aplicativo_nutricao/view/login_page.dart';
import 'package:aplicativo_nutricao/view/cadastro_page.dart';
import 'package:aplicativo_nutricao/view/creditos_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        title: const Text('Home'),
        centerTitle: true,
        titleTextStyle: titlemenu,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            color: const Color.fromRGBO(244, 100, 114, 1),
            tooltip: 'Logout',
            padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
            onPressed: () {
              logout();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(232, 255, 213, 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Nutrify.png',
                      height: 90,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Nutrify permite que você cadastre e consulte cardápios além de compartilhar com amigos",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "MENU",
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(244, 100, 114, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 10),
                children: [
                  _buildMenuButton(
                    context,
                    "Cadastrar",
                    "Cadastre novos alimentos\ne cardápios.",
                    const Color.fromRGBO(232, 255, 213, 1),
                    cadastrarAlimentoCardapio,
                  ),
                  const SizedBox(height: 20),
                  _buildMenuButton(
                    context,
                    "Consultar",
                    "Encontre novos alimentos\ne cardápios.",
                    const Color.fromRGBO(213, 227, 255, 1),
                    consultarAlimento,
                  ),
                  const SizedBox(height: 20),
                  _buildMenuButton(
                    context,
                    "Créditos",
                    "Conheça os desenvolvedores\ndo aplicativo.",
                    const Color.fromRGBO(255, 236, 213, 1),
                    credito,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
    VoidCallback onPressed,
  ) {
    return Container(
      height: 110,
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: color,
          alignment: Alignment.centerLeft,
          side: const BorderSide(width: 2, color: Color(0xFF000000)),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  consultarAlimento() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ConsultaPage(),
      ),
    );
  }

  static const titlemenu = TextStyle(
    color: Color.fromRGBO(244, 100, 114, 1),
    fontSize: 18.0,
  );

  cadastrarAlimentoCardapio() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroPage(),
      ),
    );
  }

  credito() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreditosPage(),
      ),
    );
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (route) => false,
    );
  }
}
