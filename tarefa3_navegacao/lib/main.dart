import 'package:flutter/material.dart';
import './themes.dart';
import './product.dart';
import './product_detail_screen.dart';

final themeManager = ThemeManager();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await themeManager.loadTheme(); // carregar tema salvo antes de runApp
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        return MaterialApp(
          title: 'Catálogo de Produtos',
          theme: lighttheme,
          darkTheme: darktheme,
          themeMode: themeManager.mode,
          home: const ProductListScreen(),
        );
      },
    );
  }
}

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Produtos'),
        actions: [
          // botão para alternar o tema
          IconButton(
            icon: Icon(
              themeManager.mode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              themeManager.toggleTheme();
            },
          ),
        ],
      ),
      body: ListView.builder(
        // lista de produtos
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(products[index].name),
            subtitle: Text(products[index].price),
            leading: Image(
              image: products[index].image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            // leva para tela de detalhes do produto
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(product: products[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}