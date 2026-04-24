import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/provider/product_provider.dart';
import '../../data/models/product.dart';
import 'product_detail_page.dart';
import 'favorites_page.dart';
import 'product_form_page.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('VTXSTORE'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.12),
          ),
        ),
        actions: [
          _CartBadge(
            count: provider.favoriteCount,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritesPage()),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _buildBody(context, provider),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProductFormPage()),
        ),
        backgroundColor: const Color(0xFF1565C0),
        tooltip: 'Adicionar produto',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProductProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFF1565C0),
              strokeWidth: 2.5,
            ),
            SizedBox(height: 16),
            Text(
              'Carregando produtos...',
              style: TextStyle(
                color: Color(0xFF0D2137),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D2137).withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.wifi_off_rounded,
                  size: 48,
                  color: Color(0xFF0D2137),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Sem conexão',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0D2137),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                provider.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Color(0xFF5A7080)),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => context.read<ProductProvider>().fetchProducts(),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.58,
      ),
      itemCount: provider.products.length,
      itemBuilder: (context, index) {
        return _ProductCard(product: provider.products[index]);
      },
    );
  }
}

class _CartBadge extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _CartBadge({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Badge(
      isLabelVisible: count > 0,
      label: Text(
        '$count',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFF1565C0),
      child: IconButton(
        icon: const Icon(Icons.shopping_cart_outlined),
        color: Colors.white,
        onPressed: onTap,
        tooltip: 'Carrinho',
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final isFav = provider.isFavorite(product.id);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailPage(product: product),
        ),
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageArea(context, isFav),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0D2137),
                        height: 1.3,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductFormPage(product: product),
                              ),
                            ),
                            icon: const Icon(Icons.edit_outlined, size: 14),
                            label: const Text('Editar',
                                style: TextStyle(fontSize: 11)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF1565C0),
                              side: const BorderSide(
                                  color: Color(0xFF1565C0), width: 1),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _confirmDelete(context),
                            icon: const Icon(Icons.delete_outline_rounded,
                                size: 14),
                            label: const Text('Excluir',
                                style: TextStyle(fontSize: 11)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFB00020),
                              side: const BorderSide(
                                  color: Color(0xFFB00020), width: 1),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir produto'),
        content: Text('Deseja excluir "${product.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFB00020)),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ProductProvider>().deleteProduct(product.id);
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  Widget _buildImageArea(BuildContext context, bool isFav) {
    return Stack(
      children: [
        Container(
          height: 150,
          color: Colors.white,
          child: Hero(
            tag: 'product-${product.id}',
            child: Image.network(
              product.image,
              fit: BoxFit.contain,
              width: double.infinity,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: Color(0xFF1565C0),
                  ),
                );
              },
              errorBuilder: (_, __, ___) => const Center(
                child: Icon(
                  Icons.broken_image_outlined,
                  color: Colors.black26,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: _FavoriteButton(productId: product.id, isFavorite: isFav),
        ),
      ],
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final int productId;
  final bool isFavorite;

  const _FavoriteButton({required this.productId, required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => context.read<ProductProvider>().toggleFavorite(productId),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            isFavorite ? Icons.shopping_cart : Icons.shopping_cart_outlined,
            size: 18,
            color: isFavorite ? const Color(0xFF1565C0) : const Color(0xFF9DB0C0),
          ),
        ),
      ),
    );
  }
}
