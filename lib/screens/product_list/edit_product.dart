import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../services/api_service.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({
    super.key,
    required this.product,
  });

  @override
  State<EditProductScreen> createState() =>
      _EditProductScreenState();
}

class _EditProductScreenState
    extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final ApiService _apiService = ApiService();

  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController stockController;
  late TextEditingController descriptionController;
  late TextEditingController imageController;

  String? selectedCategory;

  bool isLoading = false;

  final List<String> categories = [
    'Laptop',
    'Komputer',
    'Monitor',
    'Aksesoris Komputer',
    'Keyboard',
    'Mouse',
    'Headset',
    'Elektronik',
    'Makanan',
    'Smartphone',
    'Tablet',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.product.name,
    );

    priceController = TextEditingController(
      text: widget.product.price.toStringAsFixed(0),
    );

    stockController = TextEditingController(
      text: widget.product.stock.toString(),
    );

    descriptionController = TextEditingController(
      text: widget.product.description,
    );

    imageController = TextEditingController(
      text: widget.product.image,
    );

    // Pastikan kategori lama tetap bisa ditampilkan.
    if (categories.contains(widget.product.category)) {
      selectedCategory = widget.product.category;
    } else if (widget.product.category.isNotEmpty) {
      categories.add(widget.product.category);
      selectedCategory = widget.product.category;
    }
  }

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
  // UPDATE PRODUCT
  // ==========================================

  Future<void> updateProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedCategory == null ||
        selectedCategory!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Kategori produk wajib dipilih.',
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final updatedProduct =
          await _apiService.updateProduct(
        id: widget.product.id.toString(),
        name: nameController.text.trim(),
        price: double.parse(
          priceController.text.trim(),
        ),
        quantity: int.parse(
          stockController.text.trim(),
        ),
        category: selectedCategory!,
        description:
            descriptionController.text.trim(),
        imageUrl: imageController.text.trim(),
      );

      if (!mounted) return;

      // Jika server mengembalikan data product
      if (updatedProduct != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Produk berhasil diperbarui di server.',
            ),
          ),
        );

        Navigator.pop(
          context,
          updatedProduct,
        );
      } else {
        // PATCH berhasil tetapi server tidak
        // mengembalikan object product
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Produk berhasil diperbarui.',
            ),
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal memperbarui produk: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ==========================================
  // VALIDATION
  // ==========================================

  String? validateName(String? value) {
    if (value == null ||
        value.trim().isEmpty) {
      return 'Nama produk wajib diisi';
    }

    return null;
  }

  String? validatePrice(String? value) {
    if (value == null ||
        value.trim().isEmpty) {
      return 'Harga wajib diisi';
    }

    final price =
        double.tryParse(value.trim());

    if (price == null) {
      return 'Harga harus berupa angka';
    }

    if (price < 0) {
      return 'Harga tidak boleh negatif';
    }

    return null;
  }

  String? validateStock(String? value) {
    if (value == null ||
        value.trim().isEmpty) {
      return 'Stok wajib diisi';
    }

    final stock =
        int.tryParse(value.trim());

    if (stock == null) {
      return 'Stok harus berupa angka bulat';
    }

    if (stock < 0) {
      return 'Stok tidak boleh negatif';
    }

    return null;
  }

  String? validateDescription(String? value) {
    if (value == null ||
        value.trim().isEmpty) {
      return 'Deskripsi wajib diisi';
    }

    return null;
  }

  String? validateImage(String? value) {
    if (value == null ||
        value.trim().isEmpty) {
      return 'UUID gambar wajib diisi';
    }

    return null;
  }

  // ==========================================
  // BUILD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      // ========================================
      // APP BAR
      // ========================================

      appBar: AppBar(
        title: const Text(
          'Edit Produk',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      // ========================================
      // BODY
      // ========================================

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              // ==================================
              // NAMA
              // ==================================

              TextFormField(
                controller: nameController,
                enabled: !isLoading,
                decoration:
                    const InputDecoration(
                  labelText: 'Nama Produk',
                  border:
                      OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.inventory_2),
                ),
                validator: validateName,
              ),

              const SizedBox(height: 16),

              // ==================================
              // KATEGORI
              // ==================================

              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration:
                    const InputDecoration(
                  labelText:
                      'Kategori Produk',
                  border:
                      OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.category),
                ),
                items: categories
                    .map(
                      (category) =>
                          DropdownMenuItem<
                              String>(
                        value: category,
                        child:
                            Text(category),
                      ),
                    )
                    .toList(),
                onChanged: isLoading
                    ? null
                    : (value) {
                        setState(() {
                          selectedCategory =
                              value;
                        });
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
              // HARGA
              // ==================================

              TextFormField(
                controller: priceController,
                enabled: !isLoading,
                keyboardType:
                    TextInputType.number,
                decoration:
                    const InputDecoration(
                  labelText: 'Harga',
                  border:
                      OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.attach_money),
                ),
                validator: validatePrice,
              ),

              const SizedBox(height: 16),

              // ==================================
              // STOK
              // ==================================

              TextFormField(
                controller: stockController,
                enabled: !isLoading,
                keyboardType:
                    TextInputType.number,
                decoration:
                    const InputDecoration(
                  labelText: 'Stok',
                  border:
                      OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.inventory),
                ),
                validator: validateStock,
              ),

              const SizedBox(height: 16),

              // ==================================
              // DESKRIPSI
              // ==================================

              TextFormField(
                controller:
                    descriptionController,
                enabled: !isLoading,
                maxLines: 4,
                decoration:
                    const InputDecoration(
                  labelText:
                      'Deskripsi Produk',
                  border:
                      OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                validator:
                    validateDescription,
              ),

              const SizedBox(height: 16),

              // ==================================
              // IMAGE UUID
              // ==================================

              TextFormField(
                controller: imageController,
                enabled: !isLoading,
                decoration:
                    const InputDecoration(
                  labelText:
                      'UUID Gambar',
                  hintText:
                      'Contoh: 5ff6f2a3-3659-4d18-a729-685577bdb954',
                  border:
                      OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.image),
                ),
                validator: validateImage,
              ),

              const SizedBox(height: 8),

              const Text(
                'Masukkan UUID asset gambar, bukan URL lengkap dan bukan .jpg',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 24),

              // ==================================
              // BUTTON
              // ==================================

              ElevatedButton.icon(
                onPressed: isLoading
                    ? null
                    : updateProduct,
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(
                  isLoading
                      ? 'Menyimpan...'
                      : 'Simpan Perubahan',
                ),
                style:
                    ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  backgroundColor:
                      Colors.blue,
                  foregroundColor:
                      Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



