import 'package:flutter/foundation.dart';

import '../models/product.dart';

class ProductRepository extends ChangeNotifier {
  ProductRepository() : _products = List<Product>.from(_seedProducts);

  static const List<Product> _seedProducts = [
    Product(
      id: 'tomatoes',
      name: 'Fresh Tomatoes',
      seller: 'Farmer John',
      location: 'Kisumu, Kenya',
      price: 80,
      unit: '/kg',
      availability: '500kg',
      rating: 4.8,
      reviews: 120,
      category: 'Agriculture',
      imagePath: null,
    ),
    Product(
      id: 'eggs',
      name: 'Farm Fresh Eggs',
      seller: 'Agri Queen',
      location: 'Nakuru, Kenya',
      price: 350,
      unit: '/tray',
      availability: '200 trays',
      rating: 4.9,
      reviews: 98,
      category: 'Agriculture',
      imagePath: null,
    ),
    Product(
      id: 'fertilizer',
      name: 'DAP Fertilizer (50kg)',
      seller: 'GreenGrow Supplies',
      location: 'Eldoret, Kenya',
      price: 5500,
      unit: '',
      availability: '300 bags',
      rating: 4.7,
      reviews: 56,
      category: 'Agriculture',
      imagePath: null,
    ),
  ];

  final List<Product> _products;

  List<Product> get products => List.unmodifiable(_products);

  void addProduct(Product product) {
    _products.insert(0, product);
    notifyListeners();
  }
}
