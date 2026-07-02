import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.10:8000/api';

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {
        "Accept":"application/json"
      },
    ),
  );

  Future<Response> products({String search = ""}) async{
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    return await dio.get(
      "/warehouse/products",
      queryParameters: {
        "search": search,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

  }//end

  Future<Response> scanProduct(String sku) async {

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    return await dio.get(
      "/warehouse/scan/$sku",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

  }//end

  Future<Response> stockIn(
      int productId,
      int quantity,
      ) async {

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    return await dio.post(
      "/warehouse/stock-in",
      data: {
        "product_id": productId,
        "qty": quantity,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

  }//end

  Future<Response> stockOut(
      int productId,
      int qty,
      ) async {

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    return await dio.post(
      "/warehouse/stock-out",
      data: {
        "product_id": productId,
        "qty": qty,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

  }//end

  Future<Response> returnProduct(
      int productId,
      int qty,
      String reason,
      ) async {

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    return await dio.post(
      "/warehouse/returns",
      data: {
        "product_id": productId,
        "qty": qty,
        "reason": reason,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

  }//end

  //load transaction  history
  Future<Response> transactions() async {

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    return await dio.get(
      "/warehouse/transactions",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

  }//end

  //load return history
  Future<Response> returns() async {

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    return await dio.get(
      "/warehouse/returns",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

  }//end

  //stock opname
  Future<Response> activeSession() async {

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    return await dio.get(
      "/warehouse/stock-opname/active-session",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

  }

  //save opname
  Future<Response> stockOpname(
      int productId,
      int physicalStock,
      String sessionCode,
      ) async {

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    return await dio.post(
      "/warehouse/stock-opname",
      data: {
        "product_id": productId,
        "physical_stock": physicalStock,
        "session_code": sessionCode,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

  }

  //stock opname mini sessionCode
  Future<Response> opnameHistory(String sessionCode) async {

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    return await dio.get(
      "/warehouse/stock-opname/history",
      queryParameters: {
        "session_code": sessionCode,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

  }

}