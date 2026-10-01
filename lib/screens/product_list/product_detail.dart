
import 'package:flutter/material.dart';
import '../../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Detail Produk',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Produk
            Container(
              width: double.infinity,
              height: 260,
              color: Colors.white,
              child: Image.network(
                product.image,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 80,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),

            // Informasi Produk
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Harga
                  Text(
                    'Rp ${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Informasi Stok
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.inventory_2,
                              color: Colors.blue,
                              size: 28,
                            ),
                          ),

                          const SizedBox(width: 16),

                          const Expanded(
                            child: Text(
                              'Stok Produk',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          Text(
                            '${product.stock} unit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: product.stock > 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Deskripsi
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ID Produk
                  Row(
                    children: [
                      const Icon(
                        Icons.qr_code,
                        color: Colors.grey,
                      ),

                      const SizedBox(width: 8),

                      Text(
                        'ID Produk: ${product.id}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


