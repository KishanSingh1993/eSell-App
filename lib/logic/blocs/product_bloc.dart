
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc(this.repository) : super(ProductState());

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is FetchProducts) {
      yield ProductState(isLoading: true);
      try {
        final products = await repository.fetchProducts();
        yield ProductState(isLoading: false, products: products);
      } catch (e) {
        yield ProductState(isLoading: false, error: e.toString());
      }
    }
  }
}
