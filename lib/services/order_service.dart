import 'dart:convert';

import '../models/order.dart';
import '../models/auth_token.dart';
import './firebase_service.dart';
import '../models/cart.dart';

class OrderService extends FirebaseService {
  OrderService([AuthToken? authToken]) : super(authToken);

  Future<List<OrderItem>> fetchOrders() async {
    final List<OrderItem> orders = [];

    try {
      final ordersMap = await httpFetch(
        '$databaseUrl/orders.json?auth=$token',
      ) as Map<String, dynamic>?;

      ordersMap?.forEach((orderId, orderData) {
        orders.add(
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            products: (orderData['products'] as List<dynamic>)
                .map((productData) => CartItem(
                      id: productData['id'],
                      title: productData['title'],
                      price: productData['price'],
                      quantity: productData['quantity'],
                      imageUrl: productData['imageUrl'],
                      author: productData['author'],
                      publishedDate:
                          DateTime.parse(productData['publishedDate']),
                      category: productData['category'],
                    ))
                .toList(),
            dateTime: DateTime.parse(orderData['dateTime']),
          ),
        );
      });
      return orders;
    } catch (err) {
      print(err);
      return orders;
    }
  }

  Future<OrderItem?> addOrder(OrderItem order) async {
    try {
      final newOrder = await httpFetch(
        '$databaseUrl/orders.json?auth=$token',
        method: HttpMethod.post,
        body: jsonEncode(
          {
            'amount': order.amount,
            'products': order.products
                .map((product) => {
                      'id': product.id,
                      'title': product.title,
                      'price': product.price,
                      'quantity': product.quantity,
                      'imageUrl': product.imageUrl,
                      'author': product.author,
                      'publishedDate': product.publishedDate.toIso8601String(),
                      'category': product.category,
                    })
                .toList(),
            'dateTime': order.dateTime.toIso8601String(),
          },
        ),
      ) as Map<String, dynamic>?;

      return order.copyWith(
        id: newOrder!['name'],
      );
    } catch (err) {
      print(err);
      return null;
    }
  }
}
