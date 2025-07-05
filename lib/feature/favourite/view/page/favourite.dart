import 'package:flutter/material.dart';
import 'package:ecommerce/feature/product_detail/page/view/product_details.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  final List<Map<String, dynamic>> favoriteProducts = [
    {
      'id': 1,
      'name': 'Cozy Knit Sweater',
      'price': 49.99,
      'category': 'Clothing',
      'image': 'assets/images/cozy_sweater.png',
      'color': const Color(0xFFF5F5F5),
    },
    {
      'id': 2,
      'name': 'Classic Leather Boots',
      'price': 129.99,
      'category': 'Shoes',
      'image': 'assets/images/leather_boots.png',
      'color': const Color(0xFF2C2C2C),
    },
    {
      'id': 3,
      'name': 'Vintage Denim Jacket',
      'price': 79.99,
      'category': 'Clothing',
      'image': 'assets/images/denim_jacket.png',
      'color': const Color(0xFFE8F4FD),
    },
    {
      'id': 4,
      'name': 'Silk Scarf',
      'price': 39.99,
      'category': 'Accessories',
      'image': 'assets/images/silk_scarf.png',
      'color': const Color(0xFFF0F8F0),
    },
    {
      'id': 5,
      'name': 'Minimalist Watch',
      'price': 199.99,
      'category': 'Accessories',
      'image': 'assets/images/watch.png',
      'color': const Color(0xFF2C2C2C),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Favorites',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Favorites Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: favoriteProducts.length,
                itemBuilder: (context, index) {
                  final product = favoriteProducts[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsPage(product: product),
                        ),
                      );
                    },
                    child: FavoriteProductCard(product: product),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoriteProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const FavoriteProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image Container
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: product['color'],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: _buildProductDisplay(product),
                  ),
                  // Heart icon for favorites
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Product Details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '\₹${product['price'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDisplay(Map<String, dynamic> product) {
    switch (product['name']) {
      case 'Cozy Knit Sweater':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE8D5B7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.checkroom,
                size: 40,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFD4A574),
                shape: BoxShape.circle,
              ),
            ),
          ],
        );
      case 'Classic Leather Boots':
        return Container(
          width: 80,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFFB08968),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.work_outline,
            size: 40,
            color: Colors.white,
          ),
        );
      case 'Vintage Denim Jacket':
        return Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: const Color(0xFF4A90E2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.checkroom,
            size: 40,
            color: Colors.white,
          ),
        );
      case 'Silk Scarf':
        return Container(
          width: 80,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF9CAF88),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.brush,
            size: 30,
            color: Colors.white,
          ),
        );
      case 'Minimalist Watch':
        return Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: Color(0xFF555555),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.watch,
            size: 35,
            color: Colors.white,
          ),
        );
      default:
        return const Icon(
          Icons.favorite,
          size: 50,
          color: Colors.red,
        );
    }
  }
}
