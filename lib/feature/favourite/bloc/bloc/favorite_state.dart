part of 'favorite_bloc.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

final class FavoriteInitial extends FavoriteState {}

final class FavoriteLoaded extends FavoriteState {
  final List<ProductModel> favoriteProducts;
  final int favoriteCount;

  const FavoriteLoaded({
    required this.favoriteProducts,
    required this.favoriteCount,
  });

  @override
  List<Object> get props => [favoriteProducts, favoriteCount];
}

final class FavoriteError extends FavoriteState {
  final String message;

  const FavoriteError({required this.message});

  @override
  List<Object> get props => [message];
}
