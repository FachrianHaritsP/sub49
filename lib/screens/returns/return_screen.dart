import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'package:dio/dio.dart';

class ReturnScreen extends StatefulWidget {
  const ReturnScreen({super.key});

  @override
  State<ReturnScreen> createState() => _ReturnScreenState();
}

class _ReturnScreenState extends State<ReturnScreen> {

  final apiService = ApiService();

  final searchController = TextEditingController();
  final qtyController = TextEditingController();
  final reasonController = TextEditingController();

  Map<String, dynamic>? product;
  List products = [];

  Future<void> searchProduct(String keyword) async {


    if (keyword.isEmpty) {
      setState(() {
        products = [];
      });
      return;
    }

    final response = await apiService.products(
      search: keyword,
    );

    setState(() {
      products = response.data["data"]["data"];
    });

  }

  Future<void> saveReturn() async {

    if (product == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pilih produk terlebih dahulu"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (qtyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Quantity harus diisi"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final qty = int.tryParse(qtyController.text);

    if (qty == null || qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Quantity harus lebih dari 0"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Reason harus diisi"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {

      final response = await apiService.returnProduct(
        product!["id"],
        qty,
        reasonController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Return berhasil dibuat"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      qtyController.clear();
      reasonController.clear();
      searchController.clear();

      FocusScope.of(context).unfocus();

      setState(() {
        product = null;
        products = [];
      });

      print(response.data);

    } on DioException catch (e) {

      print(e.response?.data);

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Return Barang"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // SEARCH
            TextField(
              controller: searchController,
              onChanged: searchProduct,
              decoration: InputDecoration(
                hintText: "Search Product...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // LIST HASIL SEARCH
            if (products.isNotEmpty)
              Container(
                constraints: const BoxConstraints(
                  maxHeight: 200,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: products.length,
                  itemBuilder: (context, index) {

                    final item = products[index];

                    return ListTile(
                      leading: const Icon(Icons.inventory_2),
                      title: Text(item["name"]),
                      subtitle: Text(item["sku"]),
                      onTap: () {

                        setState(() {
                          product = item;
                          products = [];
                          searchController.text = item["name"];
                        });

                      },
                    );

                  },
                ),
              ),

            // CARD PRODUCT
            if (product != null) ...[

              const SizedBox(height: 20),

              Card(
                elevation: 3,
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

              // QUANTITY
              TextField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Quantity",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              // REASON
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Reason",
                  hintText: "Masukkan alasan return...",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveReturn,
                  // onPressed: () {
                  //   // saveReturn() nanti
                  // },
                  child: const Text("Save"),
                ),
              ),

            ],

          ],
        ),
      ),
    );
  }
}