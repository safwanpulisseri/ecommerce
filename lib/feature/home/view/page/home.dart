import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/feature/cart/view/page/cart.dart';
import 'package:ecommerce/feature/product_detail/page/view/product_details.dart';
import 'package:ecommerce/feature/home/bloc/bloc/product_bloc.dart';
import 'package:ecommerce/feature/home/data/model/product_model.dart';
import 'package:ecommerce/feature/cart/bloc/bloc/cart_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePageView();
  }
}

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  String selectedCategory = 'All';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final List<String> categories = [
    'All',
    'men\'s clothing',
    'women\'s clothing',
    'jewelery',
    'electronics'
  ];

  @override
  void initState() {
    super.initState();
    // Trigger initial data fetch
    context.read<ProductBloc>().add(const FetchProductsEvent());
    context.read<CartBloc>().add(const LoadCartEvent());
  }

  List<ProductModel> getFilteredProducts(List<ProductModel> products) {
    List<ProductModel> filteredProducts = products;

    // Filter by category
    if (selectedCategory != 'All') {
      filteredProducts = filteredProducts
          .where((product) => product.category == selectedCategory)
          .toList();
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filteredProducts = filteredProducts
          .where((product) =>
              product.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
              product.description
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              product.category
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
          .toList();
    }

    return filteredProducts;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Map<String, dynamic> convertProductToMap(ProductModel product) {
    return {
      'id': product.id,
      'name': product.title,
      'price': product.price,
      'category': product.category,
      'image': product.image,
      'description': product.description,
      'color': _getCategoryColor(product.category),
    };
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'men\'s clothing':
        return const Color(0xFFE8D5B7);
      case 'women\'s clothing':
        return const Color(0xFFB08968);
      case 'jewelery':
        return const Color(0xFF9CAF88);
      case 'electronics':
        return const Color(0xFF2C2C2C);
      default:
        return const Color(0xFFF5F5F5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Shop',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
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
                      color: Colors.black,
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartPage(),
                        ),
                      );
                    },
                  ),
                  if (cartCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          cartCount > 99 ? '99+' : cartCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
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
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<ProductBloc>()
                          .add(const FetchProductsEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is ProductLoaded) {
            final filteredProducts = getFilteredProducts(state.products);
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E8E8),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search products',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                            size: 24,
                          ),
                          suffixIcon: searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Category Filter Buttons
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final isSelected = selectedCategory == category;

                          return Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategory = category;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.black
                                      : const Color(0xFFE8E8E8),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: Text(
                                    category,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 16,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Products Grid
                    filteredProducts.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                children: [
                                  Icon(
                                    searchQuery.isNotEmpty
                                        ? Icons.search_off
                                        : Icons.inventory_2_outlined,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    searchQuery.isNotEmpty
                                        ? 'No products found for "$searchQuery"'
                                        : selectedCategory != 'All'
                                            ? 'No products found in this category'
                                            : 'No products available',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  if (searchQuery.isNotEmpty) ...[
                                    const SizedBox(height: 16),
                                    TextButton(
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {
                                          searchQuery = '';
                                        });
                                      },
                                      child: const Text('Clear search'),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: filteredProducts.length,
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];
                              final productMap = convertProductToMap(product);
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailsPage(
                                          product: productMap),
                                    ),
                                  );
                                },
                                child: ProductCard(product: productMap),
                              );
                            },
                          ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductCard({super.key, required this.product});

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
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: product['image'] != null && product['image'].isNotEmpty
                    ? Image.network(
                        product['image'],
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: product['color'],
                            child: Center(
                              child: _buildProductIcon(product['category']),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: product['color'],
                        child: Center(
                          child: _buildProductIcon(product['category']),
                        ),
                      ),
              ),
            ),
          ),

          // Product Details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      product['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    flex: 1,
                    child: Text(
                      '₹${(product['price'] ?? 0.0).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
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

  Widget _buildProductIcon(String category) {
    switch (category.toLowerCase()) {
      case 'men\'s clothing':
      case 'women\'s clothing':
        return const Icon(
          Icons.checkroom,
          size: 80,
          color: Colors.black54,
        );
      case 'jewelery':
        return const Icon(
          Icons.diamond,
          size: 80,
          color: Colors.black54,
        );
      case 'electronics':
        return const Icon(
          Icons.devices,
          size: 80,
          color: Colors.white,
        );
      default:
        return const Icon(
          Icons.shopping_bag_outlined,
          size: 80,
          color: Colors.black54,
        );
    }
  }
}
