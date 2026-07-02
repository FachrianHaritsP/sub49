import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class HistoryScreen extends StatefulWidget{
  final String sessionCode;
  const HistoryScreen({
    super.key,
    required this.sessionCode,
  });


  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>{

  List history = [];

  bool isLoading = true;

  final apiService = ApiService();

  @override
  void initState() {
    super.initState();

    loadHistory();
  }

  Future<void> loadHistory() async {

    final response = await apiService.opnameHistory(
      widget.sessionCode,
    );

    setState(() {

      history = response.data["data"];

      isLoading = false;

    });

  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
          title: const Text("History Stock Opname"),
        ),

      body: isLoading

          ? const Center(
        child: CircularProgressIndicator(),
      )

          : ListView.builder(

        padding: const EdgeInsets.all(16),

        itemCount: history.length,

        itemBuilder: (context,index){

          final item = history[index];

          return Card(

            margin: const EdgeInsets.only(bottom: 12),

            child: ListTile(

              title: Text(
                item["product"]["name"],
              ),

              subtitle: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(
                    "System : ${item["system_stock"]}",
                  ),

                  Text(
                    "Physical : ${item["physical_stock"]}",
                  ),

                  Text(
                    "Difference : ${item["difference"]}",
                  ),

                ],

              ),

              trailing:
              item["status"] == "match"

                  ? const Icon(
                Icons.check_circle,
                color: Colors.green,
              )

                  : const Icon(
                Icons.warning,
                color: Colors.orange,
              ),

            ),

          );

        },

      ),

    );



  }

}