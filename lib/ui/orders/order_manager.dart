import 'package:flutter/cupertino.dart';
import '../../models/auth_token.dart';
import '../../models/cart.dart';
import '../../models/order.dart';
import '../../services/order_service.dart'; // Đảm bảo import đúng đường dẫn của OrderService

class OrderManager with ChangeNotifier {
  final List<OrderItem> _orders = [];

  final OrderService _orderService;

  OrderManager([AuthToken? authToken])
      : _orderService = OrderService(authToken);

  set authToken(AuthToken? authToken) {
    _orderService.authToken = authToken;
  }

  int get orderCount {
    return _orders.length;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    try {
      List<OrderItem> fetchedOrders = await _orderService.fetchOrders();
      _orders.clear();
      _orders.addAll(fetchedOrders);
      notifyListeners();
    } catch (error) {
      print('Error fetching orders: $error');
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    try {
      OrderItem newOrder = OrderItem(
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
      );

      OrderItem? addedOrder = await _orderService.addOrder(newOrder);
      if (addedOrder != null) {
        _orders.insert(0, addedOrder);
        notifyListeners();
      }
    } catch (error) {
      print('Error adding order: $error');
    }
  }
}
