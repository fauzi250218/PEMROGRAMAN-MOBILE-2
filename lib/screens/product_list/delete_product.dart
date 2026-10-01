import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../models/product.dart';
import '../../services/api_service.dart';

class DeleteProductScreen extends SignalStatefulWidget {
  final Product product;

  const DeleteProductScreen({
    super.key,
    required this.product,
  });

  @override
  State<DeleteProductScreen> createState() =>
      _DeleteProductScreenState();
}

class _DeleteProductScreenState
    extends State<DeleteProductScreen> {
  final ApiService apiService = ApiService();

  // ==========================================
  // SIGNAL STATE
  // ==========================================

  final isLoading = signal(false);

  // ==========================================
  // DELETE PRODUCT
  // ==========================================

  Future<void> deleteProduct() async {
    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    try {
      // ========================================
      // DELETE KE API
      // ========================================

      await apiService.deleteProduct(
        id: widget.product.id,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Produk berhasil dihapus',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Kembali ke halaman sebelumnya
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        isLoading.value = false;
      }
    }
  }

  // ==========================================
  // BUILD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delete Product',
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            // ==================================
            // ICON
            // ==================================

            const Icon(
              Icons.warning_amber_rounded,
              size: 70,
              color: Colors.orange,
            ),

            const SizedBox(height: 16),

            // ==================================
            // KONFIRMASI
            // ==================================

            Text(
              'Apakah kamu yakin ingin menghapus '
              '${widget.product.name}?',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 24),

            // ==================================
            // BUTTON
            // ==================================

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                // BATAL
                OutlinedButton(
                  onPressed:
                      isLoading.value
                          ? null
                          : () {
                              Navigator.pop(
                                context,
                              );
                            },
                  child: const Text(
                    'Batal',
                  ),
                ),

                const SizedBox(width: 16),

                // HAPUS
                ElevatedButton(
                  onPressed:
                      isLoading.value
                          ? null
                          : deleteProduct,
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Hapus',
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
