import 'package:get/get.dart';

import '../../data/model/cart_item.dart';
import '../../data/model/product.dart';


class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;

  void addToCart(Product product) {
    var index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      cartItems[index].quantity++;
    } else {
      cartItems.add(CartItem(product: product));
    }
  }

  void removeFromCart(Product product) {
    cartItems.removeWhere((item) => item.product.id == product.id);
  }

  double get totalPrice => cartItems.fold(0, (sum, item) => sum + item.product.price * item.quantity);
}
