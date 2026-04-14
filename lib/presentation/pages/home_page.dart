import 'package:flutter/material.dart';
import 'provider_page.dart';
import 'riverpod_page.dart';
import 'bloc_page.dart';
import 'products_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("State Management Examples")),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Provider Example"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProviderPage()),
              );
            },
          ),
          ListTile(
            title: const Text("Riverpod Example"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RiverpodPage()),
              );
            },
          ),
          ListTile(
            title: const Text("BLoC Example"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BlocPage()),
              );
            },
          ),
          ListTile(
            title: const Text("Produtos (VTXSTORE)"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProductsPage()),
            ),
          ),
        ],
      ),
    );
  }
}
