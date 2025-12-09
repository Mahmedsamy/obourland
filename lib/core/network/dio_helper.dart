// import 'package:dio/dio.dart';
// import '../cache/cache_helper.dart';
//
//
// class DioHelper {
//   static Dio? _dio;
//   static const baseUrl = 'https://example.com/api'; // change to your API
//
//
//   static void init() {
//     _dio = Dio(BaseOptions(baseUrl: baseUrl, receiveDataWhenStatusError: true));
//   }
//
//
//   static Future<Response> post(String path, {Map<String, dynamic>? data, Map<String, dynamic>? query}) async {
//     final token = CacheHelper.getData(key: 'token');
//     try {
//       return await _dio!.post(path,
//           data: data,
//           queryParameters: query,
//           options: Options(headers: token != null ? {'Authorization': 'Bearer \$token'} : null));
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//
//   static Future<Response> get(String path, {Map<String, dynamic>? query}) async {
//     final token = CacheHelper.getData(key: 'token');
//     try {
//       return await _dio!.get(path,
//           queryParameters: query,
//           options: Options(headers: token != null ? {'Authorization': 'Bearer \$token'} : null));
//     } catch (e) {
//       rethrow;
//     }
//   }
// }

import 'package:dio/dio.dart';
import '../cache/cache_helper.dart';

class DioHelper {
  static late Dio _dio;

  static const String baseUrl = "https://example.com/api"; // ← حط URL السيرفر هنا

  // ============================================================
  // INIT
  // ============================================================
  static void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );

    // For debugging requests in console
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
        responseHeader: false,
      ),
    );
  }

  // ============================================================
  // TOKEN HEADER BUILDER
  // ============================================================
  static Options _setHeaders() {
    final token = CacheHelper.getData(key: "token");

    return Options(
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );
  }

  // ============================================================
  // POST
  // ============================================================
  static Future<Response> post(
      String path, {
        Map<String, dynamic>? data,
        Map<String, dynamic>? query,
      }) async {
    return await _dio.post(
      path,
      data: data,
      queryParameters: query,
      options: _setHeaders(),
    );
  }

  // ============================================================
  // GET
  // ============================================================
  static Future<Response> get(
      String path, {
        Map<String, dynamic>? query,
      }) async {
    return await _dio.get(
      path,
      queryParameters: query,
      options: _setHeaders(),
    );
  }

  // ============================================================
  // PUT
  // ============================================================
  static Future<Response> put(
      String path, {
        Map<String, dynamic>? data,
        Map<String, dynamic>? query,
      }) async {
    return await _dio.put(
      path,
      data: data,
      queryParameters: query,
      options: _setHeaders(),
    );
  }

  // ============================================================
  // DELETE
  // ============================================================
  static Future<Response> delete(
      String path, {
        Map<String, dynamic>? query,
      }) async {
    return await _dio.delete(
      path,
      queryParameters: query,
      options: _setHeaders(),
    );
  }
}
