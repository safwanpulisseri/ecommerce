import 'package:bloc/bloc.dart';
import 'package:ecommerce/feature/home/data/model/product_model.dart';
import 'package:ecommerce/feature/home/data/repository/product_repo.dart';
import 'package:equatable/equatable.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepo _productRepo;
  static const int _productsPerPage = 10;
  List<ProductModel> _allProducts = [];

  ProductBloc(this._productRepo) : super(ProductInitial()) {
    on<FetchProductsEvent>(_onFetchProducts);
    on<LoadInitialProductsEvent>(_onLoadInitialProducts);
    on<LoadMoreProductsEvent>(_onLoadMoreProducts);
  }

  Future<void> _onFetchProducts(
      FetchProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await _productRepo.fetchProducts();
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> _onLoadInitialProducts(
      LoadInitialProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      // Fetch all products from API
      _allProducts = await _productRepo.fetchAllProducts();

      // Return first page of products
      final initialProducts = _allProducts.take(_productsPerPage).toList();

      emit(ProductLoaded(
        products: initialProducts,
        currentPage: 1,
        hasMore: _allProducts.length > _productsPerPage,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> _onLoadMoreProducts(
      LoadMoreProductsEvent event, Emitter<ProductState> emit) async {
    final currentState = state;
    if (currentState is ProductLoaded &&
        currentState.hasMore &&
        !currentState.isLoadingMore) {
      emit(currentState.copyWith(isLoadingMore: true));

      try {
        // Simulate loading delay for better UX
        await Future.delayed(const Duration(milliseconds: 500));

        // Calculate the next batch of products
        final startIndex = currentState.currentPage * _productsPerPage;
        final endIndex = startIndex + _productsPerPage;

        final nextProducts = _allProducts.sublist(
          startIndex,
          endIndex > _allProducts.length ? _allProducts.length : endIndex,
        );

        final allDisplayedProducts = [
          ...currentState.products,
          ...nextProducts
        ];

        emit(ProductLoaded(
          products: allDisplayedProducts,
          currentPage: currentState.currentPage + 1,
          hasMore: allDisplayedProducts.length < _allProducts.length,
          isLoadingMore: false,
        ));
      } catch (e) {
        emit(currentState.copyWith(isLoadingMore: false));
      }
    }
  }
}
