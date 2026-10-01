import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../models/product.dart';
import '../../services/api_service.dart';
import '../../widgets/product_card.dart';

import 'add_product.dart';
import 'edit_product.dart';
import 'search_product.dart';

class ProductListScreen extends SignalStatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() =>
      _ProductListScreenState();
}

class _ProductListScreenState
    extends State<ProductListScreen> {
  final ApiService apiService = ApiService();

  final isLoading = signal(true);
  final errorMessage = signal<String?>(null);
  final products = signal<List<Product>>([]);
  final isDeleting = signal(false);

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  // ==========================================
  // GET PRODUCTS DARI API
  // ==========================================

  Future<void> loadProducts() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final savedProducts =
          await apiService.getProducts();

      if (!mounted) return;

      products.value = savedProducts;
      isLoading.value = false;
    } catch (e) {
      if (!mounted) return;

      isLoading.value = false;

      errorMessage.value = e
          .toString()
          .replaceFirst('Exception: ', '');
    }
  }

  // ==========================================
  // MEMBUKA HALAMAN TAMBAH
  // ==========================================

  Future<void> openAddProduct() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const AddProductScreen(),
      ),
    );

    await loadProducts();
  }

  // ==========================================
  // MEMBUKA HALAMAN EDIT
  // ==========================================

  Future<void> openEditProduct(
    Product product,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditProductScreen(
          product: product,
        ),
      ),
    );

    await loadProducts();
  }

  // ==========================================
  // DELETE PRODUCT
  // ==========================================

  Future<void> deleteProduct(
    Product product,
  ) async {
    final bool? confirm =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Hapus Produk',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Apakah kamu yakin ingin menghapus '
            'produk "${product.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    isDeleting.value = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await apiService.deleteProduct(
        id: product.id,
      );

      if (!mounted) return;

      Navigator.pop(context);

      products.value = products.value
          .where(
            (item) => item.id != product.id,
          )
          .toList();

      isDeleting.value = false;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Produk berhasil dihapus',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      Navigator.pop(context);

      isDeleting.value = false;

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
          'Daftar Produk',
        ),
        centerTitle: true,
        actions: [
          // ==================================
          // SEARCH
          // ==================================

          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const SearchProductScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.search,
            ),
            tooltip: 'Cari produk',
          ),

          // ==================================
          // REFRESH
          // ==================================

          IconButton(
            onPressed:
                isLoading.value
                    ? null
                    : loadProducts,
            icon: const Icon(
              Icons.refresh,
            ),
            tooltip: 'Muat ulang',
          ),
        ],
      ),

      // ======================================
      // BODY
      // ======================================

      body: _buildBody(),

      // ======================================
      // TAMBAH PRODUK
      // ======================================

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed:
            isDeleting.value
                ? null
                : openAddProduct,
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          'Tambah',
        ),
      ),
    );
  }

  // ==========================================
  // BODY
  // ==========================================

  Widget _buildBody() {
    // ========================================
    // LOADING
    // ========================================

    if (isLoading.value) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // ========================================
    // ERROR
    // ========================================

    if (errorMessage.value != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 60,
                color: Colors.red,
              ),

              const SizedBox(height: 16),

              const Text(
                'Gagal mengambil data produk',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                errorMessage.value!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: loadProducts,
                icon: const Icon(
                  Icons.refresh,
                ),
                label: const Text(
                  'Coba Lagi',
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ========================================
    // DATA KOSONG
    // ========================================

    if (products.value.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada produk',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
    }

    // ========================================
    // LIST PRODUK
    // ========================================

    return RefreshIndicator(
      onRefresh: loadProducts,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: products.value.length,
        itemBuilder: (
          BuildContext context,
          int index,
        ) {
          final product =
              products.value[index];

          return ProductCard(
            product: product,

            // ==================================
            // EDIT
            // ==================================

            onEdit: () {
              openEditProduct(product);
            },

            // ==================================
            // DELETE
            // ==================================

            onDelete: () {
              deleteProduct(product);
            },
          );
        },
      ),
    );
  }
}
