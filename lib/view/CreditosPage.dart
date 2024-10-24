import 'package:flutter/material.dart';

class CreditosPage extends StatefulWidget {
  const CreditosPage({super.key});

  @override
  State<CreditosPage> createState() => _CreditosPageState();
}

class _CreditosPageState extends State<CreditosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Creditos Page"),
      ),
    );
  }
}
