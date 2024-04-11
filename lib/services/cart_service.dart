import 'dart:convert';
import '../models/auth_token.dart';
import '../models/cart.dart';
import '../models/product.dart';
import './firebase_service.dart';

class CartService extends FirebaseService {
  CartService([AuthToken? authToken]) : super(authToken);

  Future<List<CartItem>> fetchCartItems() async {
    final List<CartItem> cartItems = [];

    try {
      final cartItemsMap = await httpFetch(
        '$databaseUrl/cart/$userId.json?auth=$token',
      ) as Map<String, dynamic>?;

      cartItemsMap?.forEach((cartItemId, cartItemData) {
        cartItems.add(
          CartItem(
            id: cartItemId,
            title: cartItemData['title'],
            price: cartItemData['price'],
            quantity: cartItemData['quantity'],
            imageUrl: cartItemData['imageUrl'],
            author: cartItemData['author'],
            publishedDate: DateTime.parse(cartItemData['publishedDate']),
            category: cartItemData['category'],
          ),
        );
      });
      return cartItems;
    } catch (error) {
      print(error);
      return cartItems;
    }
  }

  Future<bool> addToCart(Product product) async {
    try {
      final cartItemsMap = await httpFetch(
        '$databaseUrl/cart/$userId.json?auth=$token',
      ) as Map<String, dynamic>?;

      final existingCartItem = cartItemsMap?.values.firstWhere(
        (item) => item['productId'] == product.id,
        orElse: () => null,
      );

      if (existingCartItem != null) {
        print('Sản phẩm đã có trong giỏ hàng');
        final updatedQuantity = existingCartItem['quantity'] + 1;
        final updatedPrice = product.price * updatedQuantity;
        await updateCartItem(
            existingCartItem['id'], updatedQuantity, updatedPrice);
      } else {
        print('Sản phẩm chưa có trong giỏ hàng');
        await httpFetch(
          '$databaseUrl/cart/$userId.json?auth=$token',
          method: HttpMethod.post,
          body: jsonEncode(
            {
              'productId': product.id,
              'title': product.title,
              'price': product.price,
              'quantity': 1,
              'imageUrl': product.imageUrl,
              'author': product.author,
              'publishedDate': product.publishedDate.toIso8601String(),
              'category': product.category,
            },
          ),
        );
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<void> updateCartItem(
      String cartItemId, int quantity, double? price) async {
    try {
      // Kiểm tra nếu giá trị price là null, thì sử dụng giá trị mặc định là 0
      final updatedPrice = price ?? 0;

      await httpFetch(
        '$databaseUrl/cart/$userId/$cartItemId.json?auth=$token',
        method: HttpMethod.put,
        body: jsonEncode({
          'quantity': quantity,
          'price': updatedPrice,
        }),
      );
    } catch (error) {
      print('Error updating cart item: $error');
    }
  }

  Future<bool> removeFromCart(String cartItemId) async {
    try {
      final response = await httpFetch(
        '$databaseUrl/cart/$userId/$cartItemId.json?auth=$token',
        method: HttpMethod.delete,
      );
      return response != null;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> clearCart() async {
    try {
      final response = await httpFetch(
        '$databaseUrl/cart/$userId.json?auth=$token',
        method: HttpMethod.delete,
      );
      return response != null;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
