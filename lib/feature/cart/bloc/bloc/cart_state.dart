part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

final class CartInitial extends CartState {}

final class CartLoaded extends CartState {
  final List<CartModel> cartItems;
  final double totalAmount;
  final int totalItems;

  const CartLoaded({
    required this.cartItems,
    required this.totalAmount,
    required this.totalItems,
  });

  @override
  List<Object> get props => [cartItems, totalAmount, totalItems];
}

final class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object> get props => [message];
}

final class CartCheckoutSuccess extends CartState {
  final double totalAmount;
  final int totalItems;

  const CartCheckoutSuccess({
    required this.totalAmount,
    required this.totalItems,
  });

  @override
  List<Object> get props => [totalAmount, totalItems];
}
