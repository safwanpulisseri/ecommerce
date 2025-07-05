part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class FetchProductsEvent extends ProductEvent {
  const FetchProductsEvent();
}

class LoadInitialProductsEvent extends ProductEvent {
  const LoadInitialProductsEvent();
}

class LoadMoreProductsEvent extends ProductEvent {
  const LoadMoreProductsEvent();
}
