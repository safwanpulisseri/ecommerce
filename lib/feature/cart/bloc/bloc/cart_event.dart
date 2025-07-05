part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCartEvent extends CartEvent {
  const LoadCartEvent();
}

class AddToCartEvent extends CartEvent {
  final ProductModel product;
  final int quantity;

  const AddToCartEvent({required this.product, this.quantity = 1});

  @override
  List<Object> get props => [product, quantity];
}

class RemoveFromCartEvent extends CartEvent {
  final int productId;

  const RemoveFromCartEvent({required this.productId});

  @override
  List<Object> get props => [productId];
}

class UpdateQuantityEvent extends CartEvent {
  final int productId;
  final int newQuantity;

  const UpdateQuantityEvent(
      {required this.productId, required this.newQuantity});

  @override
  List<Object> get props => [productId, newQuantity];
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}

class CheckoutEvent extends CartEvent {
  const CheckoutEvent();
}
