import 'package:flutter/material.dart';

import '../models/product.dart';
import '../screens/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductCard({
    super.key,
    required this.product,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(
                product: product,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // GAMBAR PRODUK
            // ==========================================

            SizedBox(
              width: double.infinity,
              height: 180,
              child: Image.network(
                'https://pos.cicd.web.id/assets/${product.image}',
                fit: BoxFit.cover,

                // Saat gambar sedang dimuat
                loadingBuilder: (
                  context,
                  child,
                  loadingProgress,
                ) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress
                                    .expectedTotalBytes !=
                                null
                            ? loadingProgress
                                    .cumulativeBytesLoaded /
                                loadingProgress
                                    .expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },

                // Jika gambar gagal dimuat
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),

            // ==========================================
            // INFORMASI PRODUK
            // ==========================================

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // ====================================
                  // KATEGORI
                  // ====================================

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(
                        alpha: 0.1,
                      ),
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.category,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ====================================
                  // NAMA PRODUK
                  // ====================================

                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ====================================
                  // HARGA
                  // ====================================

                  Text(
                    'Rp ${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ====================================
                  // STOK + ACTION
                  // ====================================

                  Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 18,
                        color: product.stock > 0
                            ? Colors.green
                            : Colors.red,
                      ),

                      const SizedBox(width: 6),

                      Text(
                        'Stok: ${product.stock}',
                        style: TextStyle(
                          color: product.stock > 0
                              ? Colors.green
                              : Colors.red,
                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),

                      const Spacer(),

                      // ==================================
                      // EDIT
                      // ==================================

                      if (onEdit != null)
                        IconButton(
                          onPressed: onEdit,
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.orange,
                          ),
                          tooltip: 'Edit produk',
                        ),

                      // ==================================
                      // DELETE
                      // ==================================

                      if (onDelete != null)
                        IconButton(
                          onPressed: onDelete,
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          tooltip: 'Hapus produk',
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}