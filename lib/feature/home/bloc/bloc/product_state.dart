part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  const ProductLoaded({
    required this.products,
    this.currentPage = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  @override
  List<Object> get props => [products, currentPage, hasMore, isLoadingMore];

  ProductLoaded copyWith({
    List<ProductModel>? products,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

final class ProductError extends ProductState {
  final String message;

  const ProductError({required this.message});

  @override
  List<Object> get props => [message];
}
