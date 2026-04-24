import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:provider/provider.dart';

import 'presentation/pages/products_page.dart';
import 'state/provider/product_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProductProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VTXSTORE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF0D2137),
          onPrimary: Colors.white,
          secondary: Color(0xFF1565C0),
          onSecondary: Colors.white,
          surface: Color(0xFFF0F4F8),
          onSurface: Color(0xFF0D2137),
          error: Color(0xFFB00020),
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF0F4F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D2137),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.15,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shadowColor: const Color(0xFF0D2137).withValues(alpha: 0.12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFF0D2137).withValues(alpha: 0.08),
          labelStyle: const TextStyle(
            color: Color(0xFF0D2137),
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1565C0),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
      home: const ProductsPage(),
=======
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
>>>>>>> 5d0b39e590879cf450a6c897b10eb46a7d959bc6
    );
  }
}
