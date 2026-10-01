import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';

class ProductStorage {
  static const String _key = 'products';

  // Mengambil data product dari penyimpanan lokal
  static Future<List<Product>?> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();

    // Jika belum ada data yang tersimpan
    if (!prefs.containsKey(_key)) {
      return null;
    }

    final data = prefs.getString(_key);

    if (data == null) {
      return [];
    }

    final List<dynamic> jsonList = jsonDecode(data);

    return jsonList
        .map(
          (item) => Product.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  // Menyimpan data product
  static Future<void> saveProducts(
    List<Product> products,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonList = products
        .map((product) => product.toJson())
        .toList();

    await prefs.setString(
      _key,
      jsonEncode(jsonList),
    );
  }

  // Menghapus seluruh data product
  static Future<void> clearProducts() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }
}