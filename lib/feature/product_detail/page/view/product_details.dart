import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/feature/cart/bloc/bloc/cart_bloc.dart';
import 'package:ecommerce/feature/home/data/model/product_model.dart';

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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.favorite_border,
              color: Colors.black,
              size: 24,
            ),
            onPressed: () {
              // Toggle favorite
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Added to favorites'),
                ),
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFE8B878),
                    const Color(0xFFD4A574),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Container(
                    height: 300,
                    width: 300,
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

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('${productModel.title} added to cart'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A90E2),
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
