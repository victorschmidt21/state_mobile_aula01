import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_arquitetura_02/data/datasources/product_cache_datasource.dart';
import 'package:mobile_arquitetura_02/data/datasources/product_remote_datasource.dart';
import 'package:mobile_arquitetura_02/data/repositories/product_repository_impl.dart';
import 'package:mobile_arquitetura_02/presentation/pages/product_page.dart';
import 'package:mobile_arquitetura_02/presentation/viewmodels/product_viewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  final datasource = ProductRemoteDatasource(http.Client());
  final cache = ProductCacheDatasource();
  final repository = ProductRepositoryImpl(datasource, cache);

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final ProductRepositoryImpl repository;
  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductViewmodel(repository),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Products',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1E88E5),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const ProductPage(),
      ),
    );
  }
}
