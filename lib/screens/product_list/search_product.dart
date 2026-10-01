import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../models/product.dart';
import '../../services/api_service.dart';
import '../../widgets/product_card.dart';

class SearchProductScreen extends SignalStatefulWidget {
  const SearchProductScreen({super.key});

  @override
  State<SearchProductScreen> createState() =>
      _SearchProductScreenState();
}

class _SearchProductScreenState
    extends State<SearchProductScreen> {
  final ApiService apiService = ApiService();

  // ==========================================
  // SIGNAL STATE
  // ==========================================

  final products = signal<List<Product>>([]);

  final keyword = signal('');

  final isLoading = signal(true);

  final errorMessage = signal<String?>(null);

  // ==========================================
  // COMPUTED STATE
  // ==========================================

  late final filteredProducts = computed(() {
    final searchKeyword =
        keyword.value.toLowerCase().trim();

    if (searchKeyword.isEmpty) {
      return products.value;
    }

    return products.value.where((product) {
      final productName =
          product.name.toLowerCase();

      final productCategory =
          product.category.toLowerCase();

      return productName.contains(searchKeyword) ||
          productCategory.contains(searchKeyword);
    }).toList();
  });

  // ==========================================
  // INIT
  // ==========================================

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  // ==========================================
  // LOAD PRODUCTS DARI API
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
          .replaceFirst(
            'Exception: ',
            '',
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
          'Search Product',
        ),
        actions: [
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

      body: isLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage.value != null
              ? _buildError()
              : _buildSearchContent(),
    );
  }

  // ==========================================
  // SEARCH CONTENT
  // ==========================================

  Widget _buildSearchContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // ==================================
          // SEARCH FIELD
          // ==================================

          TextField(
            onChanged: (value) {
              keyword.value = value;
            },
            decoration: InputDecoration(
              hintText:
                  'Cari nama atau kategori...',
              prefixIcon: const Icon(
                Icons.search,
              ),
              suffixIcon:
                  keyword.value.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            keyword.value = '';
                          },
                          icon: const Icon(
                            Icons.clear,
                          ),
                        )
                      : null,
              border:
                  const OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          // ==================================
          // HASIL PENCARIAN
          // ==================================

          Expanded(
            child:
                filteredProducts.value.isEmpty
                    ? const Center(
                        child: Text(
                          'Produk tidak ditemukan',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount:
                            filteredProducts
                                .value
                                .length,
                        itemBuilder:
                            (
                              context,
                              index,
                            ) {
                          final product =
                              filteredProducts
                                  .value[index];

                          return ProductCard(
                            product: product,
                            onEdit: null,
                            onDelete: null,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // ERROR
  // ==========================================

  Widget _buildError() {
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
              errorMessage.value ?? '',
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
}