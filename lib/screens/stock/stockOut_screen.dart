import 'package:flutter/material.dart';

class StockoutScreen extends StatelessWidget {
  const StockoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock-Out Screen"),
      ),
      body: const Center(
        child: Text(
          "Stock-Out Screen",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

}