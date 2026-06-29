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

}