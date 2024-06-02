import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/providers/api_provider.dart';
import '../../data/repositories/product_repository.dart';
import '../../logic/blocs/product_bloc.dart';
import '../../logic/blocs/product_event.dart';
import '../../logic/blocs/product_state.dart';
import '../../logic/controllers/cart_controller.dart';
import '../../logic/controllers/product_controller.dart';
import '../../logic/providers/product_provider.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apiProvider = ApiProvider();
    final productRepository = ProductRepository(apiProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('eSell App'),
        bottom: const TabBar(
          tabs: [
            Tab(text: 'GetX'),
            Tab(text: 'BLoC'),
            Tab(text: 'Provider'),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          GetXScreen(repository: productRepository),
          BlocScreen(repository: productRepository),
          ProviderScreen(repository: productRepository),
        ],
      ),
    );
  }
}

class GetXScreen extends StatelessWidget {
  final ProductRepository repository;
  GetXScreen({required this.repository});

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.put(ProductController(repository));
    final CartController cartController = Get.put(CartController());

    return Obx(() {
      if (productController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
          ),
          itemCount: productController.productList.length,
          itemBuilder: (context, index) {
            var product = productController.productList[index];
            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(
                    product.image,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text('\$${product.price}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      cartController.addToCart(product);
                    },
                    child: const Text('Add to Cart'),
                  ),
                ],
              ),
            );
          },
        );
      }
    });
  }
}

class BlocScreen extends StatelessWidget {
  final ProductRepository repository;
  BlocScreen({required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductBloc(repository)..add(FetchProducts()),
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.error != null) {
            return Center(child: Text(state.error!));
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                var product = state.products[index];
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.network(
                        product.image,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Text('\$${product.price}', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          // Handle Add to Cart for BLoC
                        },
                        child: const Text('Add to Cart'),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ProviderScreen extends StatelessWidget {
  final ProductRepository repository;
  ProviderScreen({required this.repository});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductProvider(repository),
      child: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: provider.products.length,
              itemBuilder: (context, index) {
                var product = provider.products[index];
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.network(
                        product.image,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                            SizedBox(height: 4),
                            Text('\$${product.price}', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          // Handle Add to Cart for Provider
                        },
                        child: const Text('Add to Cart'),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
