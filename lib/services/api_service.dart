import 'package:dio/dio.dart';

import '../models/product.dart';

class ApiService {
  static const String baseUrl =
      'https://pos.cicd.web.id';

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(
        seconds: 10,
      ),
      receiveTimeout: const Duration(
        seconds: 10,
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // ==========================================
  // GET PRODUCTS
  // ==========================================

  Future<List<Product>> getProducts() async {
    try {
      final response = await dio.get(
        '/items/products',
      );

      final responseData = response.data;

      if (responseData is! Map) {
        throw Exception(
          'Format response dari server tidak sesuai.',
        );
      }

      final data = responseData['data'];

      if (data is! List) {
        throw Exception(
          'Data products dari server tidak sesuai.',
        );
      }

      return data
          .map(
            (json) => Product.fromJson(
              Map<String, dynamic>.from(json),
            ),
          )
          .toList();
    } on DioException catch (e) {
      throw Exception(
        _getDioErrorMessage(e),
      );
    } catch (e) {
      throw Exception(
        'Terjadi kesalahan: $e',
      );
    }
  }

  // ==========================================
  // POST PRODUCT
  // ==========================================

  Future<Product?> addProduct({
    required String name,
    required double price,
    required int quantity,
    required String category,
    required String description,
    String? imageUrl,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'name': name,
        'price': price,
        'quantity': quantity,
        'category': category,
        'description': description,
      };

      // image_url dikirim jika ada
      if (imageUrl != null &&
          imageUrl.trim().isNotEmpty) {
        data['image_url'] = imageUrl.trim();
      }

      print(
        '========== POST PRODUCT ==========',
      );
      print(
        'URL: $baseUrl/items/products',
      );
      print('DATA: $data');

      final response = await dio.post(
        '/items/products',
        data: data,
      );

      print(
        'STATUS: ${response.statusCode}',
      );
      print(
        'RESPONSE: ${response.data}',
      );
      print(
        '==================================',
      );

      final responseData = response.data;

      if (responseData is Map &&
          responseData['data'] is Map) {
        return Product.fromJson(
          Map<String, dynamic>.from(
            responseData['data'],
          ),
        );
      }

      return null;
    } on DioException catch (e) {
      print(
        '========== POST PRODUCT ERROR ==========',
      );
      print(
        'STATUS: ${e.response?.statusCode}',
      );
      print(
        'RESPONSE: ${e.response?.data}',
      );
      print(
        'REQUEST: ${e.requestOptions.data}',
      );
      print('TYPE: ${e.type}');
      print('MESSAGE: ${e.message}');
      print(
        '=========================================',
      );

      throw Exception(
        _getDioErrorMessage(e),
      );
    } catch (e) {
      print(
        'POST PRODUCT ERROR: $e',
      );

      throw Exception(
        'Terjadi kesalahan: $e',
      );
    }
  }

  // ==========================================
  // PATCH PRODUCT
  // ==========================================

  Future<Product?> updateProduct({
    required String id,
    required String name,
    required double price,
    required int quantity,
    required String category,
    required String description,
    String? imageUrl,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'name': name,
        'price': price,
        'quantity': quantity,
        'category': category,
        'description': description,
      };

      // image_url hanya dikirim jika diisi
      if (imageUrl != null &&
          imageUrl.trim().isNotEmpty) {
        data['image_url'] = imageUrl.trim();
      }

      print(
        '========== PATCH PRODUCT ==========',
      );
      print(
        'URL: $baseUrl/items/products/$id',
      );
      print('DATA: $data');

      final response = await dio.patch(
        '/items/products/$id',
        data: data,
      );

      print(
        'STATUS: ${response.statusCode}',
      );
      print(
        'RESPONSE: ${response.data}',
      );
      print(
        '===================================',
      );

      final responseData = response.data;

      if (responseData is Map &&
          responseData['data'] is Map) {
        return Product.fromJson(
          Map<String, dynamic>.from(
            responseData['data'],
          ),
        );
      }

      return null;
    } on DioException catch (e) {
      print(
        '========== PATCH PRODUCT ERROR ==========',
      );
      print(
        'STATUS: ${e.response?.statusCode}',
      );
      print(
        'RESPONSE: ${e.response?.data}',
      );
      print(
        'REQUEST: ${e.requestOptions.data}',
      );
      print('TYPE: ${e.type}');
      print('MESSAGE: ${e.message}');
      print(
        '==========================================',
      );

      throw Exception(
        _getDioErrorMessage(e),
      );
    } catch (e) {
      print(
        'PATCH PRODUCT ERROR: $e',
      );

      throw Exception(
        'Terjadi kesalahan: $e',
      );
    }
  }

  // ==========================================
  // DELETE PRODUCT
  // ==========================================

  Future<void> deleteProduct({
    required String id,
  }) async {
    try {
      print(
        '========== DELETE PRODUCT ==========',
      );
      print(
        'URL: $baseUrl/items/products/$id',
      );

      final response = await dio.delete(
        '/items/products/$id',
      );

      print(
        'STATUS: ${response.statusCode}',
      );
      print(
        'RESPONSE: ${response.data}',
      );
      print(
        '===================================',
      );
    } on DioException catch (e) {
      print(
        '========== DELETE PRODUCT ERROR ==========',
      );

      print(
        'STATUS: ${e.response?.statusCode}',
      );

      print(
        'RESPONSE: ${e.response?.data}',
      );

      print(
        'REQUEST URL: ${e.requestOptions.uri}',
      );

      print(
        'REQUEST DATA: ${e.requestOptions.data}',
      );

      print(
        'TYPE: ${e.type}',
      );

      print(
        'MESSAGE: ${e.message}',
      );

      print(
        '==========================================',
      );

      throw Exception(
        _getDioErrorMessage(e),
      );
    } catch (e) {
      print(
        'DELETE PRODUCT ERROR: $e',
      );

      throw Exception(
        'Terjadi kesalahan: $e',
      );
    }
  }

  // ==========================================
  // DIO ERROR HANDLER
  // ==========================================

  String _getDioErrorMessage(
    DioException e,
  ) {
    if (e.type ==
        DioExceptionType.connectionTimeout) {
      return 'Koneksi ke server timeout.';
    }

    if (e.type ==
        DioExceptionType.receiveTimeout) {
      return 'Server terlalu lama memberikan response.';
    }

    if (e.type ==
        DioExceptionType.connectionError) {
      return 'Tidak dapat terhubung ke server.';
    }

    if (e.response != null) {
      final statusCode =
          e.response?.statusCode;

      final responseData =
          e.response?.data;

      // Jika server mengembalikan JSON error
      if (responseData is Map) {
        final error =
            responseData['errors'];

        if (error != null) {
          return 'Server error ($statusCode): $error';
        }

        final message =
            responseData['message'];

        if (message != null) {
          return 'Server error ($statusCode): $message';
        }
      }

      // Jika response berupa String
      if (responseData is String &&
          responseData.isNotEmpty) {
        return 'Server error ($statusCode): $responseData';
      }

      return 'Server error: $statusCode';
    }

    return 'Terjadi kesalahan jaringan.';
  }
}