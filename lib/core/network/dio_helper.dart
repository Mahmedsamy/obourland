import 'package:dio/dio.dart';
import '../cache/cache_helper.dart';


class DioHelper {
  static Dio? _dio;
  static const baseUrl = 'https://example.com/api'; // change to your API


  static void init() {
    _dio = Dio(BaseOptions(baseUrl: baseUrl, receiveDataWhenStatusError: true));
  }


  static Future<Response> post(String path, {Map<String, dynamic>? data, Map<String, dynamic>? query}) async {
    final token = CacheHelper.getData(key: 'token');
    try {
      return await _dio!.post(path,
          data: data,
          queryParameters: query,
          options: Options(headers: token != null ? {'Authorization': 'Bearer \$token'} : null));
    } catch (e) {
      rethrow;
    }
  }


  static Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    final token = CacheHelper.getData(key: 'token');
    try {
      return await _dio!.get(path,
          queryParameters: query,
          options: Options(headers: token != null ? {'Authorization': 'Bearer \$token'} : null));
    } catch (e) {
      rethrow;
    }
  }
}