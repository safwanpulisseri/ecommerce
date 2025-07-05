part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class LoadFavoritesEvent extends FavoriteEvent {
  const LoadFavoritesEvent();
}

class ToggleFavoriteEvent extends FavoriteEvent {
  final ProductModel product;

  const ToggleFavoriteEvent({required this.product});

  @override
  List<Object> get props => [product];
}

class RemoveFromFavoritesEvent extends FavoriteEvent {
  final int productId;

  const RemoveFromFavoritesEvent({required this.productId});

  @override
  List<Object> get props => [productId];
}

class ClearAllFavoritesEvent extends FavoriteEvent {
  const ClearAllFavoritesEvent();
}
