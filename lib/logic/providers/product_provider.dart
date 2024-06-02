import 'package:flutter/material.dart';

import '../../data/model/product.dart';
import '../../data/repositories/product_repository.dart';


class ProductProvider with ChangeNotifier {
  bool isLoading = true;
  List<Product> products = [];
  final ProductRepository repository;

  ProductProvider(this.repository) {
    fetchProducts();
  }

  void fetchProducts() async {
    isLoading = true;
    notifyListeners();
    try {
      products = await repository.fetchProducts();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
