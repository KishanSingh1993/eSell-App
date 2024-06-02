

import '../../data/model/product.dart';

class ProductState {
  final bool isLoading;
  final List<Product> products;
  final String? error;

  ProductState({this.isLoading = false, this.products = const [], this.error});
}
