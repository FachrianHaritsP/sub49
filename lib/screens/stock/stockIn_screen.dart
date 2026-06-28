import 'package:flutter/material.dart';

class StockinScreen extends StatelessWidget {
  const StockinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock-In Screen"),
      ),
      body: const Center(
        child: Text(
          "Stock-In Screen",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

}