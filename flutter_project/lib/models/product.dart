class Product {
  const Product({
    required this.id,
    required this.name,
    required this.seller,
    required this.location,
    required this.price,
    required this.unit,
    required this.availability,
    required this.rating,
    required this.reviews,
    required this.category,
    this.imagePath,
  });

  final String id;
  final String name;
  final String seller;
  final String location;
  final double price;
  final String unit;
  final String availability;
  final double rating;
  final int reviews;
  final String category;
  final String? imagePath;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Product',
      seller: json['seller'] as String? ?? 'Seller',
      location: json['location'] as String? ?? 'Location unavailable',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] as String? ?? '',
      availability: json['availability'] as String? ?? 'Not specified',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviews: json['reviews'] as int? ?? 0,
      category: json['category'] as String? ?? 'General',
      imagePath: json['imagePath'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'seller': seller,
      'location': location,
      'price': price,
      'unit': unit,
      'availability': availability,
      'rating': rating,
      'reviews': reviews,
      'category': category,
      'imagePath': imagePath,
    };
  }
}
