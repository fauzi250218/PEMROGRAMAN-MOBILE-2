import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../services/api_service.dart';

class AddProductScreen extends SignalStatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() =>
      _AddProductScreenState();
}

class _AddProductScreenState
    extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final descriptionController =
      TextEditingController();
  final imageController = TextEditingController();

  final ApiService apiService = ApiService();

  // ==========================================
  // SIGNAL STATE
  // ==========================================

  final isLoading = signal(false);

  final selectedCategory = signal<String?>(null);

  // ==========================================
  // DATA KATEGORI
  // ==========================================

  final List<String> categories = [
    'Laptop',
    'Smartphone',
    'Tablet',
    'Aksesoris',
    'Lainnya',
  ];

  // ==========================================
  // DISPOSE
  // ==========================================

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
    descriptionController.dispose();
    imageController.dispose();

    super.dispose();
  }

  // ==========================================
  // TAMBAH PRODUK
  // ==========================================

  Future<void> addProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    try {
      final String name =
          nameController.text.trim();

      final double price = double.parse(
        priceController.text.trim(),
      );

      final int quantity = int.parse(
        stockController.text.trim(),
      );

      final String description =
          descriptionController.text.trim();

      final String imageUrl =
          imageController.text.trim();

      // ========================================
      // POST KE API
      // ========================================

      await apiService.addProduct(
        name: name,
        price: price,
        quantity: quantity,
        category: selectedCategory.value!,
        description: description,
        imageUrl:
            imageUrl.isEmpty ? null : imageUrl,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Produk berhasil ditambahkan',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Kembali ke Product List
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
  // VALIDASI FIELD WAJIB
  // ==========================================

  String? validateRequired(
    String? value,
    String fieldName,
  ) {
    if (value == null ||
        value.trim().isEmpty) {
      return '$fieldName wajib diisi';
    }

    return null;
  }

  // ==========================================
  // BUILD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Produk',
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // ==================================
              // NAMA PRODUK
              // ==================================

              TextFormField(
                controller: nameController,
                enabled: !isLoading.value,
                decoration:
                    const InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.shopping_bag),
                ),
                validator: (value) {
                  return validateRequired(
                    value,
                    'Nama produk',
                  );
                },
              ),

              const SizedBox(height: 16),

              // ==================================
              // HARGA
              // ==================================

              TextFormField(
                controller: priceController,
                enabled: !isLoading.value,
                keyboardType:
                    TextInputType.number,
                decoration:
                    const InputDecoration(
                  labelText: 'Harga',
                  hintText:
                      'Contoh: 5000000',
                  border: OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Harga wajib diisi';
                  }

                  final double? price =
                      double.tryParse(
                    value.trim(),
                  );

                  if (price == null ||
                      price < 0) {
                    return 'Masukkan harga yang valid';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ==================================
              // STOK
              // ==================================

              TextFormField(
                controller: stockController,
                enabled: !isLoading.value,
                keyboardType:
                    TextInputType.number,
                decoration:
                    const InputDecoration(
                  labelText: 'Stok',
                  hintText: 'Contoh: 10',
                  border: OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.inventory),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Stok wajib diisi';
                  }

                  final int? stock =
                      int.tryParse(
                    value.trim(),
                  );

                  if (stock == null ||
                      stock < 0) {
                    return 'Masukkan stok yang valid';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ==================================
              // KATEGORI
              // ==================================

              DropdownButtonFormField<String>(
                initialValue:
                    selectedCategory.value,
                decoration:
                    const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.category),
                ),
                items: categories.map(
                  (category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  },
                ).toList(),
                onChanged: isLoading.value
                    ? null
                    : (value) {
                        selectedCategory.value =
                            value;
                      },
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Kategori wajib dipilih';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ==================================
              // DESKRIPSI
              // ==================================

              TextFormField(
                controller:
                    descriptionController,
                enabled: !isLoading.value,
                maxLines: 4,
                decoration:
                    const InputDecoration(
                  labelText:
                      'Deskripsi Produk',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                  prefixIcon:
                      Icon(Icons.description),
                ),
                validator: (value) {
                  return validateRequired(
                    value,
                    'Deskripsi',
                  );
                },
              ),

              const SizedBox(height: 16),

              // ==================================
              // GAMBAR
              // ==================================

              TextFormField(
                controller: imageController,
                enabled: !isLoading.value,
                decoration:
                    const InputDecoration(
                  labelText: 'URL Gambar',
                  hintText:
                      'Masukkan UUID asset gambar',
                  border: OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.image),
                ),
                validator: (value) {
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // ==================================
              // TOMBOL SIMPAN
              // ==================================

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed:
                      isLoading.value
                          ? null
                          : addProduct,
                  icon: isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.save,
                        ),
                  label: Text(
                    isLoading.value
                        ? 'Menyimpan...'
                        : 'Simpan Produk',
                  ),
                  style:
                      ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
