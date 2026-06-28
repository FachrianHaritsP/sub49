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
  );//end

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
  }//end

  Future<Response> user(String token) async {

    return await dio.get(
      "/user",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

  }//end

  Future<Response> logout(String token) async {

    return await dio.post(
      "/logout",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

  }//end

}//main class