

import '../model/product.dart';
import '../providers/api_provider.dart';

class ProductRepository {
  final ApiProvider apiProvider;

  ProductRepository(this.apiProvider);

  Future<List<Product>> fetchProducts() async {
    final products = await apiProvider.fetchProducts();
    return products.map((product) => Product.fromJson(product)).toList();
  }
}
