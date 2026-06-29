import 'package:flutter/material.dart';
import '../scanner/scanner_screen.dart';
import '../../services/api_service.dart';
import 'package:dio/dio.dart';

class StockInScreen extends StatefulWidget {
  const StockInScreen({super.key});

  @override
  State<StockInScreen> createState() => _StockInScreenState();
}

class _StockInScreenState extends State<StockInScreen> {

  Map<String, dynamic>? product;

  final qtyController = TextEditingController();
  final apiService = ApiService();


  @override

  Future<void> scanProduct() async {

    final sku = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ScannerScreen(),
      ),
    );

    if (sku == null) return;

    final response = await apiService.scanProduct(sku);

    setState(() {
      product = response.data["data"];
    });

  }

  Future<void> saveStockIn() async {

    if (product == null) return;

    if (qtyController.text.isEmpty) return;

    try {

      final response = await apiService.stockIn(
        product!["id"],
        int.parse(qtyController.text),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Stock In berhasil"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      qtyController.clear();

      FocusScope.of(context).unfocus();

      setState(() {
        product = null;
      });

      print(response.data);

    } on DioException catch (e) {

      print(e.response?.data);

    }

  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock In"),
      ),
      body: Column(
        children: [

          if(product == null)
          ElevatedButton(
          onPressed: scanProduct,
          child: const Text("Scan QR"),
          ),


          const SizedBox(height: 20),

          if (product != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      product!["name"],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text("SKU : ${product!["sku"]}"),
                    Text("Size : ${product!["size"]}"),
                    Text("Color : ${product!["color"]}"),
                    Text("Stock : ${product!["stock"]}"),

                  ],
                ),
              ),
            ),

          const SizedBox(height: 20),

          TextField(
            controller: qtyController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Quantity",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [

              Expanded(
                child: OutlinedButton(
                  onPressed: scanProduct,
                  child: const Text("Scan Lagi"),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton(
                  onPressed: saveStockIn,
                  child: const Text("Save"),
                ),
              ),

            ],
          ),

        ],
      ),

    );
  }
}