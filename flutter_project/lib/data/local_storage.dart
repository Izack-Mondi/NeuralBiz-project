import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';

import '../models/product.dart';

class LocalStorage extends ChangeNotifier {
  static const String _boxName = 'listings';
  static const String _keyItems = 'items';
  List<Product> _products = <Product>[];

  List<Product> get products => List.unmodifiable(_products);

  Future<List<Product>> loadListings() async {
    final box = Hive.box(_boxName);
    final raw = box.get(_keyItems, defaultValue: <dynamic>[]);
    if (raw is List) {
      _products = raw
          .whereType<Map>()
          .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      notifyListeners();
      return List<Product>.from(_products);
    }
    _products = <Product>[];
    notifyListeners();
    return <Product>[];
  }

  Future<void> saveListings(List<Product> items) async {
    final box = Hive.box(_boxName);
    await box.put(_keyItems, items.map((item) => item.toJson()).toList());
    _products = List<Product>.from(items);
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final items = await loadListings();
    items.insert(0, product);
    await saveListings(items);
  }

  Future<void> clearAll() async {
    final box = Hive.box(_boxName);
    await box.delete(_keyItems);
    _products = <Product>[];
    notifyListeners();
  }
}
