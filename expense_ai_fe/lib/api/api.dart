import 'package:dio/dio.dart';
import 'package:expense_ai_fe/api/interceptors.dart';
import 'package:flutter/material.dart';

class APIClient {
  final Dio _dio;

  APIClient()
      : _dio = Dio(BaseOptions(
            baseUrl:  "/api", // "https://expenseai.swninja.win/api",  // "http://localhost:5003/api",// "https://expenseai.swninja.win/api",
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 20))) {
    _dio.interceptors.add(AuthInterceptor());
  }
  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    try {
      return await _dio.get(endpoint, queryParameters: queryParams);
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String endpoint, {dynamic data}) async {
    try {
      return await _dio.post(endpoint, data: data);
    } on DioException catch (e) {
      rethrow;
    }
  }
}
