import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {

  List products = [];

  final apiService = ApiService();
  final searchController = TextEditingController();

  @override
  void initState(){
    super.initState();

    loadProducts();
  }

  Future<void> loadProducts([String search = ""]) async {

   // final response = await apiService.products();
    final response = await apiService.products(
      search: search,
    );

    setState(() {
      products = response.data["data"]["data"];
    });

    //print(response.data);

  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: searchController,
              onChanged: (value) {
                loadProducts(value);
              },
              decoration: InputDecoration(
                hintText: "Search Product...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {

                  final product = products[index];

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const Icon(
                        Icons.inventory_2,
                        size: 40,
                        color: Colors.blue,
                      ),

                      title: Text(
                        product["name"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const SizedBox(height: 6),

                          Text("Size : ${product["size"]}"),
                          Text("Color : ${product["color"]}"),

                          const SizedBox(height: 6),

                          Text(
                            "Stock : ${product["stock"]} pcs",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        ],
                      ),

                      onTap: () {

                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    product["name"],
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  Text("SKU : ${product["sku"]}"),
                                  Text("Size : ${product["size"]}"),
                                  Text("Color : ${product["color"]}"),

                                  Text(
                                    "Rack : ${product["rack_slot"]["rack"]["rack_code"]}-${product["rack_slot"]["slot_code"]}",
                                  ),

                                  Text("Stock : ${product["stock"]} pcs"),

                                  const SizedBox(height: 20),

                                  SizedBox(
                                    width: double.infinity,
                                    child: FilledButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Close"),
                                    ),
                                  ),

                                ],
                              ),
                            );
                          },
                        );

                      },
                    ),
                  );

                },
              ),
            ),

          ],
        ),
      ),


    );

  }

}//end _Inve