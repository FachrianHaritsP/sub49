import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String token = "";

  @override
  void initState() {
    super.initState();
    loadToken();
  }

  Future<void> loadToken() async {

    final prefs = await SharedPreferences.getInstance();

    setState(() {
      token = prefs.getString("token") ?? "Token tidak ditemukan";
    });

  }

  Future<void> logout() async {

    final prefs = await SharedPreferences.getInstance();

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

      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Login Berhasil",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),



            const SizedBox(height: 20),

            const Text(
              "Sanctum Token:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            SelectableText(token),

          ],
        ),
      ),
    );
  }
}