import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerce/feature/product_detail/page/view/product_details.dart';
import 'package:ecommerce/feature/home/bloc/bloc/product_bloc.dart';
import 'package:ecommerce/feature/home/data/model/product_model.dart';
import 'package:ecommerce/feature/cart/bloc/bloc/cart_bloc.dart';
import 'package:ecommerce/feature/favourite/bloc/bloc/favorite_bloc.dart';
import 'package:ecommerce/feature/navbar/bloc/bloc/navbar_bloc.dart';
import 'package:ecommerce/core/theme/color/app_color.dart';
import 'package:shimmer/shimmer.dart';

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
  final ScrollController _scrollController = ScrollController();
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
    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final currentState = context.read<ProductBloc>().state;
      if (currentState is ProductLoaded &&
          currentState.hasMore &&
          !currentState.isLoadingMore) {
        context.read<ProductBloc>().add(const LoadMoreProductsEvent());
      }
    }
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
    _scrollController.dispose();
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
      backgroundColor: AppColor.surfaceVariant,
      appBar: AppBar(
        backgroundColor: AppColor.surface,
        elevation: 0,
        title: const Text(
          'Shop',
          style: TextStyle(
            color: AppColor.textPrimary,
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
                      color: AppColor.textPrimary,
                      size: 28,
                    ),
                    onPressed: () {
                      // Switch to cart tab instead of navigating
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
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const ShimmerLoadingWidget();
          } else if (state is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColor.textHint,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColor.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<ProductBloc>()
                          .add(const LoadInitialProductsEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is ProductLoaded) {
            final filteredProducts = getFilteredProducts(state.products);
            return SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.surfaceContainer,
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
                            color: AppColor.textHint,
                            fontSize: 16,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColor.textHint,
                            size: 24,
                          ),
                          suffixIcon: searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: AppColor.textHint,
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
                                      ? AppColor.selectedTab
                                      : AppColor.surfaceContainer,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: Text(
                                    category,
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColor.surface
                                          : AppColor.textPrimary,
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
                                    color: AppColor.textHint,
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
                                      color: AppColor.textSecondary,
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
                                child: ProductCard(
                                  product: productMap,
                                  productModel: product,
                                ),
                              );
                            },
                          ),

                    // Loading more indicator
                    if (state.isLoadingMore) ...[
                      const SizedBox(height: 16),
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                      const SizedBox(height: 16),
                    ],
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

// Shimmer Loading Widget
class ShimmerLoadingWidget extends StatelessWidget {
  const ShimmerLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shimmer Search Bar
            Shimmer.fromColors(
              baseColor: AppColor.shimmerBase,
              highlightColor: AppColor.shimmerHighlight,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColor.surface,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Shimmer Category Filters
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Shimmer.fromColors(
                      baseColor: AppColor.shimmerBase,
                      highlightColor: AppColor.shimmerHighlight,
                      child: Container(
                        width: 80,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColor.surface,
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Shimmer Products Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return const ShimmerProductCard();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Shimmer Product Card
class ShimmerProductCard extends StatelessWidget {
  const ShimmerProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBase,
      highlightColor: AppColor.shimmerHighlight,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadow,
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image container
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColor.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
              ),
            ),
            // Details container
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14,
                      width: double.infinity,
                      color: AppColor.surface,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 14,
                      width: 100,
                      color: AppColor.surface,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 12,
                      width: 60,
                      color: AppColor.surface,
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
}

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final ProductModel productModel;

  const ProductCard({
    super.key,
    required this.product,
    required this.productModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadow,
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
                color: AppColor.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: product['image'] != null &&
                            product['image'].isNotEmpty
                        ? Image.network(
                            product['image'],
                            fit: BoxFit.contain,
                            width: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
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
                  // Favorite Icon
                  Positioned(
                    top: 8,
                    right: 8,
                    child: BlocBuilder<FavoriteBloc, FavoriteState>(
                      builder: (context, state) {
                        bool isFavorite = false;
                        if (state is FavoriteLoaded) {
                          isFavorite = state.favoriteProducts.any(
                            (fav) => fav.id == productModel.id,
                          );
                        }

                        return GestureDetector(
                          onTap: () {
                            context.read<FavoriteBloc>().add(
                                  ToggleFavoriteEvent(product: productModel),
                                );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColor.surface.withOpacity(0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.shadow,
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite
                                  ? AppColor.favorite
                                  : AppColor.unselectedTab,
                              size: 18,
                            ),
                          ),
                        );
                      },
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
                        color: AppColor.textPrimary,
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
                        color: AppColor.textSecondary,
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
          color: AppColor.textSecondary,
        );
      case 'jewelery':
        return const Icon(
          Icons.diamond,
          size: 80,
          color: AppColor.textSecondary,
        );
      case 'electronics':
        return const Icon(
          Icons.devices,
          size: 80,
          color: AppColor.surface,
        );
      default:
        return const Icon(
          Icons.shopping_bag_outlined,
          size: 80,
          color: AppColor.textSecondary,
        );
    }
  }
}
