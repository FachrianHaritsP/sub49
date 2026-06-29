import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>{

  List transactions = [];

  final apiService = ApiService();

  @override
  void initState(){
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {

    final transactionResponse = await apiService.transactions();
    final returnResponse = await apiService.returns();

    //ambil data
    List transactionData =
    transactionResponse.data["data"]["data"];
    List returnData =
    returnResponse.data["data"]["data"];

    print(returnResponse.data);

    //gabungkan
    List allHistory = [];

    allHistory.addAll(transactionData);

    for (var item in returnData) {
      item["type"] = "return";
    }

    allHistory.addAll(returnData);

    //sort
    allHistory.sort((a, b) =>
        DateTime.parse(b["created_at"])
            .compareTo(DateTime.parse(a["created_at"])));

    setState(() {
      transactions = allHistory;
    });

  }

  IconData getTransactionIcon(String? type) {
    switch (type) {
      case "in":
        return Icons.south;
      case "out":
        return Icons.north;
      case "return":
        return Icons.assignment_return;
      default:
        return Icons.receipt_long;
    }
  }

  Color getTransactionColor(String? type) {
    switch (type) {
      case "in":
        return Colors.green;
      case "out":
        return Colors.red;
      case "return":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String getTransactionTitle(String type) {
    switch (type) {
      case "in":
        return "Stock In";
      case "out":
        return "Stock Out";
      case "return":
        return "Return";
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
      ),

      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {

          final transaction = transactions[index];

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: ListTile(

              leading: Icon(
                getTransactionIcon(transaction["type"]),
                color: getTransactionColor(transaction["type"]),
              ),

              title: Text(
                transaction["product"]["name"],
              ),

              subtitle: Text(
                "${getTransactionTitle(transaction["type"])} • Qty : ${transaction["qty"]}",
              ),

              trailing: const Icon(Icons.chevron_right),

              onTap: () {
                // Detail nanti
              },

            ),
          );

        },
      ),


    );


  }//end widget


}// class