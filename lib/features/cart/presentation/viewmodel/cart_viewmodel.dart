import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jerseyhub/features/cart/domain/entity/cart_entity.dart';
import 'package:jerseyhub/features/cart/domain/entity/cart_item_entity.dart';
import 'package:jerseyhub/features/product/domain/entity/product_entity.dart';
import 'package:jerseyhub/features/cart/domain/use_case/get_cart_usecase.dart';
import 'package:jerseyhub/features/cart/domain/use_case/add_to_cart_usecase.dart';
import 'package:jerseyhub/features/cart/domain/use_case/remove_from_cart_usecase.dart';
import 'package:jerseyhub/features/cart/domain/use_case/update_quantity_usecase.dart';
import 'package:jerseyhub/features/cart/domain/use_case/clear_cart_usecase.dart';
import 'package:jerseyhub/features/cart/data/services/cart_notification_service.dart';
import 'package:jerseyhub/app/shared_prefs/user_shared_prefs.dart';

// Events
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCartEvent extends CartEvent {
  final String? userId;
  const LoadCartEvent({this.userId});

  @override
  List<Object?> get props => [userId];
}

class AddToCartEvent extends CartEvent {
  final CartItemEntity item;
  final String? userId;
  const AddToCartEvent({required this.item, this.userId});

  @override
  List<Object?> get props => [item, userId];
}

class RemoveFromCartEvent extends CartEvent {
  final String itemId;
  final String? userId;
  const RemoveFromCartEvent({required this.itemId, this.userId});

  @override
  List<Object?> get props => [itemId, userId];
}

class UpdateQuantityEvent extends CartEvent {
  final String itemId;
  final int quantity;
  final String? userId;
  const UpdateQuantityEvent({
    required this.itemId,
    required this.quantity,
    this.userId,
  });

  @override
  List<Object?> get props => [itemId, quantity, userId];
}

class ClearCartEvent extends CartEvent {
  final String? userId;
  const ClearCartEvent({this.userId});

  @override
  List<Object?> get props => [userId];
}

class SyncCartEvent extends CartEvent {
  final String userId;
  const SyncCartEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

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
  final CartNotificationService _cartNotificationService;
  final UserSharedPrefs _userSharedPrefs;

  CartViewModel({
    required GetCartUseCase getCartUseCase,
    required AddToCartUseCase addToCartUseCase,
    required RemoveFromCartUseCase removeFromCartUseCase,
    required UpdateQuantityUseCase updateQuantityUseCase,
    required ClearCartUseCase clearCartUseCase,
    required CartNotificationService cartNotificationService,
    required UserSharedPrefs userSharedPrefs,
  }) : _getCartUseCase = getCartUseCase,
       _addToCartUseCase = addToCartUseCase,
       _removeFromCartUseCase = removeFromCartUseCase,
       _updateQuantityUseCase = updateQuantityUseCase,
       _clearCartUseCase = clearCartUseCase,
       _cartNotificationService = cartNotificationService,
       _userSharedPrefs = userSharedPrefs,
       super(CartInitial()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<ClearCartEvent>(_onClearCart);
    on<SyncCartEvent>(_onSyncCart);
  }

  String _getUserId(String? eventUserId) {
    return eventUserId ?? _userSharedPrefs.getCurrentUserId() ?? 'unknown_user';
  }

  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    final userId = _getUserId(event.userId);
    final result = await _getCartUseCase(GetCartParams(userId: userId));
    result.fold(
      (failure) => emit(CartError(message: failure.message)),
      (cart) => emit(CartLoaded(cart: cart)),
    );
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final userId = _getUserId(event.userId);
    final result = await _addToCartUseCase(
      AddToCartParams(userId: userId, item: event.item),
    );
    result.fold((failure) => emit(CartError(message: failure.message)), (cart) {
      // Send notification after successfully adding to cart
      _cartNotificationService.sendAddToCartNotification(
        productName: event.item.product.team,
        quantity: event.item.quantity,
      );
      emit(CartLoaded(cart: cart));
    });
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCartEvent event,
    Emitter<CartState> emit,
  ) async {
    print(
      '🔄 CartViewModel: Processing RemoveFromCartEvent for item ID: ${event.itemId}',
    );

    final userId = _getUserId(event.userId);

    // First get the current cart to find the item details
    final currentCartResult = await _getCartUseCase(
      GetCartParams(userId: userId),
    );
    CartItemEntity? itemToRemove;

    currentCartResult.fold(
      (failure) {
        print(
          '❌ CartViewModel: Failed to get current cart: ${failure.message}',
        );
        emit(CartError(message: failure.message));
        return;
      },
      (cart) {
        itemToRemove = cart.items.firstWhere(
          (item) => item.id == event.itemId,
          orElse: () => CartItemEntity(
            id: '',
            product: ProductEntity(
              id: '',
              team: 'Unknown Product',
              type: '',
              size: '',
              price: 0.0,
              quantity: 0,
              categoryId: '',
              sellerId: '',
              productImage: '',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
            quantity: 1,
            selectedSize: '',
            addedAt: DateTime.now(),
          ),
        );
      },
    );

    if (itemToRemove == null) {
      emit(CartError(message: 'Item not found in cart'));
      return;
    }

    final result = await _removeFromCartUseCase(
      RemoveFromCartParams(userId: userId, itemId: event.itemId),
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

        // Send notification after successfully removing from cart
        _cartNotificationService.sendRemoveFromCartNotification(
          productName: itemToRemove!.product.team,
          quantity: itemToRemove!.quantity,
        );

        emit(CartLoaded(cart: cart));
      },
    );
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    final userId = _getUserId(event.userId);
    final result = await _updateQuantityUseCase(
      UpdateQuantityParams(
        userId: userId,
        itemId: event.itemId,
        quantity: event.quantity,
      ),
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
    final userId = _getUserId(event.userId);
    final result = await _clearCartUseCase(ClearCartParams(userId: userId));
    result.fold(
      (failure) => emit(CartError(message: failure.message)),
      (cart) => emit(CartLoaded(cart: cart)),
    );
  }

  Future<void> _onSyncCart(SyncCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());

    // This would typically call the repository's sync method
    // For now, just load the cart normally
    final result = await _getCartUseCase(GetCartParams(userId: event.userId));
    result.fold(
      (failure) => emit(CartError(message: failure.message)),
      (cart) => emit(CartLoaded(cart: cart)),
    );
  }
}
