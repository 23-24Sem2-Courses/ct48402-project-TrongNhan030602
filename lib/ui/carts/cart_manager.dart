import 'package:flutter/foundation.dart';
import '../../services/cart_service.dart';
import '../../models/auth_token.dart';
import '../../models/cart.dart';
import '../../models/product.dart';

class CartManager with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  final CartService _cartService;

  CartManager([AuthToken? authToken]) : _cartService = CartService(authToken);

  set authToken(AuthToken? authToken) {
    _cartService.authToken = authToken;
  }

  int get productCount {
    return _items.length;
  }

  List<CartItem> get products {
    return _items.values.toList();
  }

  Iterable<MapEntry<String, CartItem>> get productEntries {
    return _items.entries;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  Future<List<CartItem>> fetchCartItems() async {
    try {
      final List<CartItem> fetchedItems = await _cartService.fetchCartItems();
      _items.clear();
      for (var item in fetchedItems) {
        _items[item.id] = item;
      }
      notifyListeners();
      return fetchedItems;
    } catch (error) {
      print('Error fetching cart items: $error');
      return [];
    }
  }

  Future<void> addItem(Product product) async {
    try {
      if (product.id != null) {
        final success = await _cartService.addToCart(product);
        if (success) {
          await fetchCartItems();
          print('Item added to cart successfully');
        }
      } else {
        print('Product ID is null');
      }
    } catch (error) {
      print('Error adding item to cart: $error');
    }
  }

  Future<void> removeItem(String cartItemId) async {
    try {
      await _cartService.removeFromCart(cartItemId);
      _items.remove(cartItemId);
      notifyListeners();
    } catch (error) {
      print('Error removing item from cart: $error');
    }
  }

  Future<void> clearItem(String cartItemId) async {
    try {
      await _cartService.removeFromCart(cartItemId);
      _items.remove(cartItemId);
      notifyListeners();
    } catch (error) {
      print('Error clearing item from cart: $error');
    }
  }

  Future<void> clearAllItems() async {
    try {
      final List<String> itemIds = _items.keys.toList();
      for (final itemId in itemIds) {
        await removeItem(itemId);
      }
      notifyListeners();
    } catch (error) {
      print('Error clearing all items from cart: $error');
    }
  }
}
