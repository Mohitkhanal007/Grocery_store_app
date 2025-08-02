import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jerseyhub/features/cart/domain/entity/cart_entity.dart';
import 'package:jerseyhub/features/cart/domain/entity/cart_item_entity.dart';
import 'package:jerseyhub/features/cart/domain/use_case/get_cart_usecase.dart';
import 'package:jerseyhub/features/cart/domain/use_case/add_to_cart_usecase.dart';
import 'package:jerseyhub/features/cart/domain/use_case/remove_from_cart_usecase.dart';
import 'package:jerseyhub/features/cart/domain/use_case/update_quantity_usecase.dart';
import 'package:jerseyhub/features/cart/domain/use_case/clear_cart_usecase.dart';

// Events
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCartEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final CartItemEntity item;
  const AddToCartEvent({required this.item});

  @override
  List<Object?> get props => [item];
}

class RemoveFromCartEvent extends CartEvent {
  final String itemId;
  const RemoveFromCartEvent({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

class UpdateQuantityEvent extends CartEvent {
  final String itemId;
  final int quantity;
  const UpdateQuantityEvent({required this.itemId, required this.quantity});

  @override
  List<Object?> get props => [itemId, quantity];
}

class ClearCartEvent extends CartEvent {}

// States
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final CartEntity cart;
  const CartLoaded({required this.cart});

  @override
  List<Object?> get props => [cart];
}

class CartError extends CartState {
  final String message;
  const CartError({required this.message});

  @override
  List<Object?> get props => [message];
}

// ViewModel
class CartViewModel extends Bloc<CartEvent, CartState> {
  final GetCartUseCase _getCartUseCase;
  final AddToCartUseCase _addToCartUseCase;
  final RemoveFromCartUseCase _removeFromCartUseCase;
  final UpdateQuantityUseCase _updateQuantityUseCase;
  final ClearCartUseCase _clearCartUseCase;

  CartViewModel({
    required GetCartUseCase getCartUseCase,
    required AddToCartUseCase addToCartUseCase,
    required RemoveFromCartUseCase removeFromCartUseCase,
    required UpdateQuantityUseCase updateQuantityUseCase,
    required ClearCartUseCase clearCartUseCase,
  }) : _getCartUseCase = getCartUseCase,
       _addToCartUseCase = addToCartUseCase,
       _removeFromCartUseCase = removeFromCartUseCase,
       _updateQuantityUseCase = updateQuantityUseCase,
       _clearCartUseCase = clearCartUseCase,
       super(CartInitial()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<ClearCartEvent>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    final result = await _getCartUseCase();
    result.fold(
      (failure) => emit(CartError(message: failure.message)),
      (cart) => emit(CartLoaded(cart: cart)),
    );
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final result = await _addToCartUseCase(AddToCartParams(item: event.item));
    result.fold(
      (failure) => emit(CartError(message: failure.message)),
      (cart) => emit(CartLoaded(cart: cart)),
    );
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCartEvent event,
    Emitter<CartState> emit,
  ) async {
    print(
      '🔄 CartViewModel: Processing RemoveFromCartEvent for item ID: ${event.itemId}',
    );
    final result = await _removeFromCartUseCase(
      RemoveFromCartParams(itemId: event.itemId),
    );
    result.fold(
      (failure) {
        print('❌ CartViewModel: Remove from cart failed: ${failure.message}');
        emit(CartError(message: failure.message));
      },
      (cart) {
        print(
          '✅ CartViewModel: Remove from cart successful. Cart now has ${cart.items.length} items',
        );
        emit(CartLoaded(cart: cart));
      },
    );
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    final result = await _updateQuantityUseCase(
      UpdateQuantityParams(itemId: event.itemId, quantity: event.quantity),
    );
    result.fold(
      (failure) => emit(CartError(message: failure.message)),
      (cart) => emit(CartLoaded(cart: cart)),
    );
  }

  Future<void> _onClearCart(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final result = await _clearCartUseCase();
    result.fold(
      (failure) => emit(CartError(message: failure.message)),
      (cart) => emit(CartLoaded(cart: cart)),
    );
  }
}
