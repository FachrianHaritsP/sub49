import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../scanner/scanner_screen.dart';
import '../opname/history_screen.dart';
import 'package:dio/dio.dart';

class OpnameScreen extends StatefulWidget {
  const OpnameScreen({super.key});

  @override
  State<OpnameScreen> createState() => _OpnameScreenState();
}

class _OpnameScreenState extends State<OpnameScreen>{

  Map<String, dynamic>? product;
  bool isLoading = true;
  Map<String, dynamic>? session;

  final searchController = TextEditingController();
  final physicalController = TextEditingController();

  final apiService = ApiService();

  List products = [];

  List history = [];

  double progress= 0;
  int checked = 0;
  int total = 0;

  @override
  void initState(){
    super.initState();

    loadSession();
  }


  Future<void> loadSession() async {

    final response = await apiService.activeSession();

    setState(() {
      session = response.data["session"];
      isLoading=false;
    });

    if (session != null) {
      await loadHistory();
    }


  }

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

  Future<void> saveStockOpname() async {

    if (product == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pilih produk terlebih dahulu"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (physicalController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Physical Stock harus diisi"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {

      final response = await apiService.stockOpname(
        product!["id"],
        int.parse(physicalController.text),
        session!["session_code"],
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Stock Opname berhasil"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      physicalController.clear();

      searchController.clear();

      FocusScope.of(context).unfocus();

      setState(() {
        product = null;
        products = [];
      });

      print(response.data);

      await loadSession();

    } on DioException catch (e) {

      print(e.response?.data);

    }

  }

  Future<void> loadHistory() async {

    final historyResponse = await apiService.opnameHistory(
      session!["session_code"],
    );

    //print(response.data);

    final productResponse = await apiService.products();

    setState(() {

      history = historyResponse.data["data"];

      checked = history.length;

      total = productResponse.data["data"]["total"];

      progress = total == 0
          ? 0
          : checked / total;

    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock Opname"),
      ),

      body:isLoading

          ? const Center(
        child: CircularProgressIndicator(),
        )

          :session == null

          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              Icons.lock_clock,
              size: 70,
              color: Colors.grey,
            ),

            SizedBox(height: 20),

            Text(
              "Stock Opname Belum Dimulai",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Silakan hubungi Leader\nuntuk membuka session.",
              textAlign: TextAlign.center,
            ),

            ],
          ),
        )

          :SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // STATUS + PROGRESS
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // STATUS
                    Row(
                      children: [

                        const Text(
                          "Status : ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [

                              Icon(
                                Icons.circle,
                                size: 12,
                                color: Colors.green,
                              ),

                              SizedBox(width: 6),

                              Text(
                                "OPEN",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                            ],
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 20),

                    // PROGRESS + HISTORY
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:  [

                            Text(
                              "Progress",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),

                            SizedBox(height: 6),

                            Text(
                              "$checked / $total Barang",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 6),

                            Text(
                              "${(progress * 100).toStringAsFixed(0)}%",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                          ],
                        ),

                        OutlinedButton.icon(
                          onPressed: () {
                            // History
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>  HistoryScreen(sessionCode: session!["session_code"],),
                              ),
                            );
                          },
                          icon: const Icon(Icons.history),
                          label: const Text("History"),
                        ),

                      ],
                    ),

                    const SizedBox(height: 24),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:  LinearProgressIndicator(

                        value: progress,
                        minHeight: 8,
                      ),
                    ),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: scanProduct,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text("Scan QR"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(55),
              ),
            ),

            const SizedBox(height: 16),

            const Center(
              child: Text(
                "atau",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 16),

            OutlinedButton.icon(
              onPressed: () {

                // Search
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,

                  builder: (_) {

                    return Padding(
                      padding: const EdgeInsets.all(16),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          TextField(
                            controller: searchController,
                            onChanged: searchProduct,
                            decoration: const InputDecoration(
                              hintText: "Cari Produk...",
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),

                          const SizedBox(height: 12),

                          SizedBox(
                            height: 250,

                            child: ListView.builder(

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

                                    });

                                    Navigator.pop(context);

                                  },

                                );

                              },

                            ),
                          ),

                        ],
                      ),
                    );

                  },

                );

              },
              icon: const Icon(Icons.search),
              label: const Text("Cari Produk"),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(55),
              ),
            ),

            if(product != null)...[

            const SizedBox(height: 24),

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

                      const Divider(),

                      Text(
                        "System Stock : ${product!["stock"]}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),
                ),
              ),

            //
            const SizedBox(height: 24),

            TextField(
              controller: physicalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Physical Stock",
                border: OutlineInputBorder(),
              ),
            ),


            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:saveStockOpname,  //save
                child: const Text("Save"),
              ),
            ),

            const SizedBox(height: 24),
            ],//end if

          ],
        ),
      ),
    );
  }


}//end class



