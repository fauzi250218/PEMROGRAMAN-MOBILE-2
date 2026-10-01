import 'package:flutter/material.dart';

import 'screens/login_page.dart';

void main() {
  runApp(const ProductCatalogApp());
}

class ProductCatalogApp extends StatelessWidget {
  const ProductCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product Catalog',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),

      // Halaman pertama aplikasi
      home: const LoginPage(),
    );
  }
}