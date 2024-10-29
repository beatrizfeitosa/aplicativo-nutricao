import 'package:flutter/material.dart';
import 'package:aplicativo_nutricao/view/consultar_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aplicativo_nutricao/view/login_page.dart';
import 'package:aplicativo_nutricao/view/cadastro_page.dart';
import 'package:aplicativo_nutricao/view/creditos_page.dart';

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
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        title: const Text('Home'),
        centerTitle: true,
        titleTextStyle: titlemenu,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            color: Color.fromRGBO(244, 100, 114, 1),
            tooltip: 'Logout',
            padding: EdgeInsets.fromLTRB(0, 0, 40, 0),
            onPressed: () {
              logout();
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 100,
              width: 350,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(232, 255, 213, 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Image.asset(
                'assets/images/Nutrify.png',
              ),
            ),
          ),
          Center(
            child: Container(
              width: 350,
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text(
                "Nutrify permite que você cadastre e consulte cardápios além de compartilhar com amigos",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                  fontSize: 14,
                )),
              ),
            ),
          ),
          Container(
            alignment: Alignment(-0.6, 0),
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Text(
              "MENU",
              style: TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(244, 100, 114, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: 100,
            width: 350,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(232, 255, 213, 1),
                  alignment: const Alignment(-1, 0),
                  side: const BorderSide(
                      width: 2, color: const Color(0xFF000000)),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)))),
              onPressed: () {
                cadastrarAlimento();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Cadastrar',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Cadastre novos alimentos\ne cardápios.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 100,
            width: 350,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(213, 227, 255, 1),
                  alignment: const Alignment(-1, 0),
                  side: const BorderSide(
                      width: 2, color: const Color(0xFF000000)),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)))),
              onPressed: () {
                consultarAlimento();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Consultar',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Encontre novos alimentos\ne cardápios.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 100,
            width: 350,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(255, 236, 213, 1),
                  alignment: const Alignment(-1, 0),
                  side: const BorderSide(
                      width: 2, color: const Color(0xFF000000)),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)))),
              onPressed: () {
                credito();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Créditos',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Conheça os desenvolvedores\ndo aplicativo.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  consultarAlimento() {
    Navigator.pushReplacement(
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

  cadastrarAlimento() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const CadastroPage(),
      ),
    );
  }

  credito() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const CreditosPage(),
      ),
    );
  }

  logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }
}
