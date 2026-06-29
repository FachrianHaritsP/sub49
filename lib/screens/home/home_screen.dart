import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';
import '../login/login_screen.dart';
import '../inventory/inventory_screen.dart';
import '../stock/stockIn_screen.dart';
import '../stock/stockOut_screen.dart';
import '../opname/opname_screen.dart';
import '../returns/return_screen.dart';
import '../history/history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String token = "";
  String name = "";
  String email = "";

  final authService = AuthService();

  @override
  void initState() {
    super.initState();
    loadToken();
  }

  Future<void> loadToken() async {

    final prefs = await SharedPreferences.getInstance();

    token = prefs.getString("token") ?? "";
    if(token.isNotEmpty){
      final response = await authService.user(token);

      setState(() {
        name = response.data["user"]["name"];
        email = response.data["user"]["email"];
      });

    }

  }

  Future<void> logout() async {

    final prefs = await SharedPreferences.getInstance();

    await authService.logout(token);
    await prefs.remove("token");

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Halaman Utama"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
          ),

        ],

      ), //appbar
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        child: Column(
          children: [

            // Card User
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [

                    const CircleAvatar(
                      radius: 28,
                      child: Icon(Icons.person),
                    ),

                    const SizedBox(width: 15),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(email),

                      ],
                    ),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Card Inventory
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const InventoryScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: const SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2,
                        size: 50,
                        color: Colors.lightBlueAccent,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Inventory",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // row 2 stock
            Row(
              children: [

                Expanded(
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StockInScreen(),
                          ),
                        );
                      },
                      child: const SizedBox(
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.move_to_inbox,
                              size: 45,
                              color: Colors.green,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Stock In",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StockOutScreen(),
                          ),
                        );
                      },
                      child: const SizedBox(
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.outbox,
                              size: 45,
                              color: Colors.red,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Stock Out",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),

            //row baru buat card sisa
            const SizedBox(height: 10),

            Row(
              children: [

                Expanded(
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OpnameScreen(),
                          ),
                        );
                      },
                      child: const SizedBox(
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fact_check,
                              size: 45,
                              color: Colors.orange,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Stock Opname",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ReturnScreen(),
                          ),
                        );
                      },
                      child: const SizedBox(
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.assignment_return,
                              size: 45,
                              color: Colors.purple,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Return",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Card History
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HistoryScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: const SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history_sharp,
                        size: 50,
                        color: Colors.brown,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "History",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

          ],// end child?
        ),
      ),



    );
  }
}