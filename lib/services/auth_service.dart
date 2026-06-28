import 'package:dio/dio.dart';
import 'api_service.dart';

class AuthService {

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiService.baseUrl,
      headers: {
        "Accept": "application/json",
      },
    ),
  );

  Future<Response> login(
      String email,
      String password,
      ) async {

    return await dio.post(
      "/login",
      data: {
        "email": email,
        "password": password,
      },
    );
  }

}