import 'package:flutter/material.dart';
import 'package:state_mobile_aula01/domain/entities/product.dart';
import 'package:state_mobile_aula01/presentation/viewmodels/product_viewmodel.dart';
import 'package:provider/provider.dart';

const _darkBlue = Color(0xFF0D1B2A);
const _midBlue = Color(0xFF1B2E4B);
const _accentBlue = Color(0xFF1E88E5);
const _lightBlue = Color(0xFF90CAF9);
const _favoriteColor = Color(0xFFFFB300);

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.watch<ProductViewmodel>();

    return Scaffold(
      backgroundColor: _darkBlue,
      appBar: AppBar(
        backgroundColor: _midBlue,
        elevation: 0,
        title: const Text(
          'Loja do Victor',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: null,
              ),
              if (viewmodel.favoriteCount > 0)
                Positioned(
                  top: 8,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: _favoriteColor,
                      shape: BoxShape.circle,
                    ),
                    constraints:
                        const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      '${viewmodel.favoriteCount}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListenableBuilder(
        listenable: viewmodel,
        builder: (context, _) {
          if (viewmodel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: _accentBlue),
            );
          }

          if (viewmodel.error != null) {
            return Center(
              child: Text(
                viewmodel.error!,
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }

          return Column(
            children: [
              _FavoriteFilterTile(viewmodel: viewmodel),
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: viewmodel.products.length,
                  itemBuilder: (context, index) {
                    return _ProductCard(
                      product: viewmodel.products[index],
                      onToggleFavorite: () => viewmodel
                          .toggleFavorite(viewmodel.products[index].id),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _accentBlue,
        onPressed: viewmodel.loadProducts,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}

class _FavoriteFilterTile extends StatelessWidget {
  final ProductViewmodel viewmodel;
  const _FavoriteFilterTile({required this.viewmodel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      decoration: BoxDecoration(
        color: _midBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: const Text(
          'Mostrar apenas favoritos',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        value: viewmodel.showOnlyFavorites,
        onChanged: viewmodel.setShowOnlyFavorites,
        activeColor: _accentBlue,
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onToggleFavorite;

  const _ProductCard({required this.product, required this.onToggleFavorite});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: product.isFavorited ? _midBlue.withValues(alpha: 0.95) : _midBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: product.isFavorited ? _favoriteColor : Colors.transparent,
          width: 1.5,
        ),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _accentBlue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '#${product.id}',
                  style: const TextStyle(
                    color: _lightBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: _lightBlue,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                product.isFavorited ? Icons.favorite : Icons.favorite_border,
                color: product.isFavorited ? _favoriteColor : Colors.white54,
              ),
              onPressed: onToggleFavorite,
            ),
          ],
        ),
      ),
    );
  }
}
