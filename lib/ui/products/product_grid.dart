import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import './product_grid_tile.dart';
import './product_manager.dart';

// Hiển thị các sản phẩm dạng lưới
class ProductsGrid extends StatelessWidget {
  final bool showFavorites;
  final List<Product> Function(String) filterProducts;

  const ProductsGrid(this.showFavorites,
      {required this.filterProducts, super.key});

  @override
  Widget build(BuildContext context) {
    final products = context.select<ProductsManager, List<Product>>(
        (productsManager) => showFavorites
            ? productsManager.favoriteItem
            : productsManager.items);

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ProductGridTile(products[i]),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 20,
      ),
    );
  }
}
