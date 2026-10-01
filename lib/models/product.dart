class Product {
  String id;
  String name;
  double price;
  int stock;
  String description;
  String image;
  String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.description,
    required this.image,
    required this.category,
  });

  // ==========================================
  // PRODUCT -> JSON
  // ==========================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': stock,
      'description': description,
      'image_url': image,
      'category': category,
    };
  }

  // ==========================================
  // JSON -> PRODUCT
  // ==========================================

  factory Product.fromJson(
    Map<String, dynamic> json,
  ) {
    return Product(
      // ID dari BaaS berupa UUID
      id: json['id']?.toString() ?? '',

      // Nama produk
      name: json['name']?.toString() ?? '',

      // Harga
      price: double.tryParse(
            json['price']?.toString() ?? '0',
          ) ??
          0.0,

      // Server menggunakan "quantity"
      stock: int.tryParse(
            json['quantity']?.toString() ?? '0',
          ) ??
          0,

      // Deskripsi
      description:
          json['description']?.toString() ?? '',

      // Server menggunakan "image_url"
      image: json['image_url']?.toString() ?? '',

      // Kategori
      category:
          json['category']?.toString() ?? '',
    );
  }
}