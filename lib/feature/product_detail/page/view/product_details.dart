import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/feature/cart/bloc/bloc/cart_bloc.dart';
import 'package:ecommerce/feature/favourite/bloc/bloc/favorite_bloc.dart';
import 'package:ecommerce/feature/home/data/model/product_model.dart';
import 'package:ecommerce/feature/navbar/bloc/bloc/navbar_bloc.dart';
import 'package:ecommerce/core/theme/color/app_color.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surfaceVariant,
      appBar: AppBar(
        backgroundColor: AppColor.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColor.textPrimary,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // Favorite Icon
          BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) {
              bool isFavorite = false;
              if (state is FavoriteLoaded) {
                isFavorite = state.favoriteProducts.any(
                  (fav) => fav.id == (widget.product['id'] ?? 0),
                );
              }

              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppColor.favorite : AppColor.textPrimary,
                  size: 24,
                ),
                onPressed: () {
                  final productModel = ProductModel(
                    id: widget.product['id'] ?? 0,
                    title: widget.product['title'] ??
                        widget.product['name'] ??
                        'Product',
                    price: (widget.product['price'] ?? 0.0).toDouble(),
                    description: widget.product['description'] ?? '',
                    category: widget.product['category'] ?? '',
                    image: widget.product['image'] ?? '',
                    rating: widget.product['rating'] != null
                        ? Rating.fromMap(widget.product['rating'])
                        : null,
                  );

                  context.read<FavoriteBloc>().add(
                        ToggleFavoriteEvent(product: productModel),
                      );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isFavorite
                          ? 'Removed from favorites'
                          : 'Added to favorites'),
                      backgroundColor:
                          isFavorite ? AppColor.warning : AppColor.success,
                    ),
                  );
                },
              );
            },
          ),
          // Cart Icon with Count
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              int cartCount = 0;
              if (state is CartLoaded) {
                cartCount = state.totalItems;
              }

              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: AppColor.textPrimary,
                      size: 24,
                    ),
                    onPressed: () {
                      // Navigate back to main app and switch to cart tab
                      Navigator.pop(context);
                      context.read<NavbarBloc>().add(const ChangeTabEvent(2));
                    },
                  ),
                  if (cartCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColor.error,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColor.surface, width: 1),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          cartCount > 99 ? '99+' : cartCount.toString(),
                          style: const TextStyle(
                            color: AppColor.surface,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Product Image Section
            Container(
              width: double.infinity,
              height: 400,
              decoration: const BoxDecoration(
                color: AppColor.surface,
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: widget.product['image'] != null
                          ? Image.network(
                              widget.product['image'],
                              fit: BoxFit.contain,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 64,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),

            // Product Details Section
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product Title
                    Text(
                      widget.product['title'] ??
                          widget.product['name'] ??
                          'Premium Cotton T-Shirt',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Product Description
                    Text(
                      widget.product['description'] ??
                          'This classic t-shirt is made from 100% premium cotton for ultimate comfort and durability. Available in a variety of colors and sizes.',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 24),

                    // Price
                    Text(
                      '₹${(widget.product['price'] ?? 29.99).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Add to Cart Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          final productModel = ProductModel(
                            id: widget.product['id'] ?? 0,
                            title: widget.product['title'] ??
                                widget.product['name'] ??
                                'Product',
                            price: (widget.product['price'] ?? 0.0).toDouble(),
                            description: widget.product['description'] ?? '',
                            category: widget.product['category'] ?? '',
                            image: widget.product['image'] ?? '',
                            rating: widget.product['rating'] != null
                                ? Rating.fromMap(widget.product['rating'])
                                : null,
                          );

                          context.read<CartBloc>().add(
                                AddToCartEvent(product: productModel),
                              );

                          // Remove from favorites when added to cart
                          context.read<FavoriteBloc>().add(
                                RemoveFromFavoritesEvent(
                                    productId: productModel.id),
                              );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('${productModel.title} added to cart'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
