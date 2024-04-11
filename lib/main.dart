import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/screeen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      secondary: Colors.orange,
      background: Colors.grey[100]!,
      surfaceTint: Colors.blueGrey[100]!,
    );

    final themData = ThemeData(
      fontFamily: 'Lato',
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        shadowColor: colorScheme.shadow,
      ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthManager(),
        ),
        ChangeNotifierProxyProvider<AuthManager, ProductsManager>(
          create: (ctx) => ProductsManager(),
          update: (ctx, authManager, productsManager) {
            productsManager!.authToken = authManager.authToken;
            return productsManager;
          },
        ),
        ChangeNotifierProxyProvider<AuthManager, CartManager>(
          create: (ctx) => CartManager(),
          update: (ctx, authManager, cartManager) {
            cartManager!.authToken = authManager.authToken;
            return cartManager;
          },
        ),
        ChangeNotifierProxyProvider<AuthManager, OrderManager>(
          create: (ctx) => OrderManager(),
          update: (ctx, authManager, orderManager) {
            orderManager!.authToken = authManager.authToken;
            return orderManager;
          },
        ),
      ],
      child: Consumer<AuthManager>(
        builder: (context, authManager, child) {
          return MaterialApp(
            title: 'MyShop',
            debugShowCheckedModeBanner: false,
            theme: themData,
            home: authManager.isAuth
                ? const SafeArea(child: ProductsOverviewScreen())
                : FutureBuilder(
                    future: authManager.tryAutoLogin(),
                    builder: (context, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? const SafeArea(child: SplashScreen())
                          : const SafeArea(child: AuthScreen());
                    },
                  ),
            // Route
            routes: {
              CartScreen.routeName: (ctx) => const SafeArea(
                    child: CartScreen(),
                  ),
              OrderScreen.routeName: (ctx) => const SafeArea(
                    child: OrderScreen(),
                  ),
              UserProductsScreen.routeName: (ctx) => const SafeArea(
                    child: UserProductsScreen(),
                  ),
            },
            //onGenerateRoute sẽ được gọi khi ko tìm thấy route yêu cầu
            onGenerateRoute: (settings) {
              if (settings.name == ProductDetailScreen.routeName) {
                final productId = settings.arguments as String;
                return MaterialPageRoute(
                  settings: settings,
                  builder: (ctx) {
                    return SafeArea(
                      child: ProductDetailScreen(
                        ctx.read<ProductsManager>().findById(productId)!,
                      ),
                    );
                  },
                );
              }
              //// Chuyển đến trang EditProductScreen
              if (settings.name == EditProductScreen.routeName) {
                final productId = settings.arguments as String?;
                return MaterialPageRoute(
                  builder: (ctx) {
                    return SafeArea(
                      child: EditProductScreen(
                        productId != null
                            ? ctx.read<ProductsManager>().findById(productId)
                            : null,
                      ),
                    );
                  },
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
