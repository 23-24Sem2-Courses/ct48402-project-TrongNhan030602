import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './order_manager.dart';
import './order_item.dart';
import '../confirm/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy thể hiện của OrderManager
    final orderManager = Provider.of<OrderManager>(context, listen: false);

    // Gọi phương thức fetchOrders để lấy danh sách đơn hàng
    orderManager.fetchOrders();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: Consumer<OrderManager>(
        builder: (ctx, ordersManager, child) {
          // Kiểm tra xem danh sách đơn hàng có rỗng không
          if (ordersManager.orders.isEmpty) {
            return const Center(
              child: Text('No orders available.'),
            );
          } else {
            // Giới hạn số lượng đơn hàng hiển thị
            final limitedOrders = ordersManager.orders.take(10).toList();

            return ListView.builder(
              itemCount: limitedOrders.length,
              itemBuilder: (ctx, index) {
                return OrderItemCard(limitedOrders[index]);
              },
            );
          }
        },
      ),
    );
  }
}
