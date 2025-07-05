import 'package:bloc/bloc.dart';
import 'package:ecommerce/feature/cart/data/model/cart_model.dart';
import 'package:ecommerce/feature/cart/data/repository/local/cart_repository.dart';
import 'package:ecommerce/feature/home/data/model/product_model.dart';
import 'package:equatable/equatable.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;

  CartBloc(this._cartRepository) : super(CartInitial()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<ClearCartEvent>(_onClearCart);
    on<CheckoutEvent>(_onCheckout);
  }

  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    try {
      await _cartRepository.init();
      final cartItems = _cartRepository.cartItems;
      final totalAmount = _cartRepository.totalAmount;
      final totalItems = _cartRepository.totalItems;

      emit(CartLoaded(
        cartItems: cartItems,
        totalAmount: totalAmount,
        totalItems: totalItems,
      ));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onAddToCart(
      AddToCartEvent event, Emitter<CartState> emit) async {
    try {
      await _cartRepository.addToCart(event.product, quantity: event.quantity);

      final cartItems = _cartRepository.cartItems;
      final totalAmount = _cartRepository.totalAmount;
      final totalItems = _cartRepository.totalItems;

      emit(CartLoaded(
        cartItems: cartItems,
        totalAmount: totalAmount,
        totalItems: totalItems,
      ));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onRemoveFromCart(
      RemoveFromCartEvent event, Emitter<CartState> emit) async {
    try {
      await _cartRepository.removeFromCart(event.productId);

      final cartItems = _cartRepository.cartItems;
      final totalAmount = _cartRepository.totalAmount;
      final totalItems = _cartRepository.totalItems;

      emit(CartLoaded(
        cartItems: cartItems,
        totalAmount: totalAmount,
        totalItems: totalItems,
      ));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onUpdateQuantity(
      UpdateQuantityEvent event, Emitter<CartState> emit) async {
    try {
      await _cartRepository.updateQuantity(event.productId, event.newQuantity);

      final cartItems = _cartRepository.cartItems;
      final totalAmount = _cartRepository.totalAmount;
      final totalItems = _cartRepository.totalItems;

      emit(CartLoaded(
        cartItems: cartItems,
        totalAmount: totalAmount,
        totalItems: totalItems,
      ));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onClearCart(
      ClearCartEvent event, Emitter<CartState> emit) async {
    try {
      await _cartRepository.clearCart();

      emit(const CartLoaded(
        cartItems: [],
        totalAmount: 0.0,
        totalItems: 0,
      ));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onCheckout(CheckoutEvent event, Emitter<CartState> emit) async {
    try {
      final totalAmount = _cartRepository.totalAmount;
      final totalItems = _cartRepository.totalItems;

      await _cartRepository.clearCart();

      emit(CartCheckoutSuccess(
        totalAmount: totalAmount,
        totalItems: totalItems,
      ));

      // After showing success, return to empty cart state
      emit(const CartLoaded(
        cartItems: [],
        totalAmount: 0.0,
        totalItems: 0,
      ));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }
}
