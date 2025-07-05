import 'package:bloc/bloc.dart';
import 'package:ecommerce/feature/home/data/model/product_model.dart';
import 'package:ecommerce/feature/home/data/repository/product_repo.dart';
import 'package:equatable/equatable.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepo _productRepo;
  ProductBloc(this._productRepo) : super(ProductInitial()) {
    on<FetchProductsEvent>(_onFetchProducts);
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
}
