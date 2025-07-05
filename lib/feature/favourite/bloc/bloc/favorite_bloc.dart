import 'package:bloc/bloc.dart';
import 'package:ecommerce/feature/favourite/data/repository/local/favourite_repository.dart';
import 'package:ecommerce/feature/home/data/model/product_model.dart';
import 'package:equatable/equatable.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository _favoriteRepository;

  FavoriteBloc(this._favoriteRepository) : super(FavoriteInitial()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<RemoveFromFavoritesEvent>(_onRemoveFromFavorites);
    on<ClearAllFavoritesEvent>(_onClearAllFavorites);
  }

  Future<void> _onLoadFavorites(
      LoadFavoritesEvent event, Emitter<FavoriteState> emit) async {
    try {
      await _favoriteRepository.init();
      final favoriteProducts = _favoriteRepository.favoriteProducts;
      final favoriteCount = _favoriteRepository.favoriteCount;

      emit(FavoriteLoaded(
        favoriteProducts: favoriteProducts,
        favoriteCount: favoriteCount,
      ));
    } catch (e) {
      emit(FavoriteError(message: e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
      ToggleFavoriteEvent event, Emitter<FavoriteState> emit) async {
    try {
      await _favoriteRepository.toggleFavorite(event.product);

      final favoriteProducts = _favoriteRepository.favoriteProducts;
      final favoriteCount = _favoriteRepository.favoriteCount;

      emit(FavoriteLoaded(
        favoriteProducts: favoriteProducts,
        favoriteCount: favoriteCount,
      ));
    } catch (e) {
      emit(FavoriteError(message: e.toString()));
    }
  }

  Future<void> _onRemoveFromFavorites(
      RemoveFromFavoritesEvent event, Emitter<FavoriteState> emit) async {
    try {
      await _favoriteRepository.removeFromFavorites(event.productId);

      final favoriteProducts = _favoriteRepository.favoriteProducts;
      final favoriteCount = _favoriteRepository.favoriteCount;

      emit(FavoriteLoaded(
        favoriteProducts: favoriteProducts,
        favoriteCount: favoriteCount,
      ));
    } catch (e) {
      emit(FavoriteError(message: e.toString()));
    }
  }

  Future<void> _onClearAllFavorites(
      ClearAllFavoritesEvent event, Emitter<FavoriteState> emit) async {
    try {
      await _favoriteRepository.clearAllFavorites();

      emit(const FavoriteLoaded(
        favoriteProducts: [],
        favoriteCount: 0,
      ));
    } catch (e) {
      emit(FavoriteError(message: e.toString()));
    }
  }

  bool isFavorite(int productId) {
    return _favoriteRepository.isFavorite(productId);
  }
}
