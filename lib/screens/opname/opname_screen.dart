import 'package:flutter/material.dart';

class OpnameScreen extends StatelessWidget {
  const OpnameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock Opname Screen"),
      ),
      body: const Center(
        child: Text(
          "Stock Opname Screen",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

}