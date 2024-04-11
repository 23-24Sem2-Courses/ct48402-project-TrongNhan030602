import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './product_detail_screen.dart';
import './top_right.dart';
import './product_grid.dart';
import '../confirm/app_drawer.dart';
import '../carts/cart_screen.dart';
import '../carts/cart_manager.dart';
import '../../models/product.dart';
import './product_manager.dart';

enum FilterOptions { favorites, all }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  final _showOnlyFavorites = ValueNotifier<bool>(false);
  final TextEditingController _searchController = TextEditingController();
  late Future<void> _fetchProducts;

  late List<Product> _allProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts = _loadProducts();
  }

  Future<void> _loadProducts() async {
    await context.read<ProductsManager>().fetchProducts();
    _updateAllProducts(context.read<ProductsManager>().items);
  }

  void _updateAllProducts(List<Product> products) {
    setState(() {
      _allProducts = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Store'),
        actions: <Widget>[
          buildProductFilterMenu(),
          buildShoppingCartIcon(),
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10.0),
                      ),
                      onChanged: _filterProducts,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      _filterProducts(_searchController.text);
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _fetchProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  return ValueListenableBuilder<bool>(
                    valueListenable: _showOnlyFavorites,
                    builder: (context, onlyFavorites, child) {
                      return _searchController.text.isNotEmpty
                          ? buildSearchResults()
                          : ProductsGrid(
                              onlyFavorites,
                              filterProducts: _filterProductsByTitle,
                            );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildShoppingCartIcon() {
    return Consumer<CartManager>(builder: (ctx, cartManager, child) {
      return TopRightBadge(
        data: cartManager.productCount,
        child: IconButton(
          icon: const Icon(
            Icons.shopping_cart,
          ),
          onPressed: () {
            Navigator.of(ctx).pushNamed(CartScreen.routeName);
          },
        ),
      );
    });
  }

  Widget buildProductFilterMenu() {
    return PopupMenuButton(
      onSelected: (FilterOptions selectedValue) {
        if (selectedValue == FilterOptions.favorites) {
          _showOnlyFavorites.value = true;
        } else {
          _showOnlyFavorites.value = false;
        }
      },
      icon: const Icon(
        Icons.more_vert,
      ),
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: FilterOptions.favorites,
          child: Text('Only Favorites'),
        ),
        const PopupMenuItem(
          value: FilterOptions.all,
          child: Text('Show All'),
        ),
      ],
    );
  }

  void _filterProducts(String query) {
    setState(() {
      // Xây dựng lại widget khi nhập từ khóa
    });
  }

  List<Product> _filterProductsByTitle(String query) {
    if (_allProducts.isEmpty) {
      // Trả về danh sách rỗng nếu products chưa được khởi tạo
      return [];
    }

    return _allProducts
        .where((product) =>
            product.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Widget buildSearchResults() {
    if (_allProducts.isEmpty) {
      return const Center(
        child: Text('No products available'),
      );
    }

    final List<Product> searchResults =
        _filterProductsByTitle(_searchController.text);

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final Product product = searchResults[index];
        return ListTile(
          title: Text(product.title),
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
        );
      },
    );
  }
}
