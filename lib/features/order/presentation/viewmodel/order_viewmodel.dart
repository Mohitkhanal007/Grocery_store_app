import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jerseyhub/features/order/domain/entity/order_entity.dart';
import 'package:jerseyhub/features/order/domain/use_case/get_all_orders_usecase.dart';
import 'package:jerseyhub/features/order/domain/use_case/get_order_by_id_usecase.dart';
import 'package:jerseyhub/features/order/domain/use_case/create_order_usecase.dart';
import 'package:jerseyhub/features/order/domain/use_case/update_order_status_usecase.dart';
import 'package:jerseyhub/features/order/domain/use_case/delete_order_usecase.dart';
import 'package:jerseyhub/app/shared_prefs/user_shared_prefs.dart';

// Events
abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllOrdersEvent extends OrderEvent {
  final String? userId;
  const LoadAllOrdersEvent({this.userId});

  @override
  List<Object?> get props => [userId];
}

class LoadOrderByIdEvent extends OrderEvent {
  final String orderId;
  const LoadOrderByIdEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class CreateOrderEvent extends OrderEvent {
  final OrderEntity order;
  const CreateOrderEvent({required this.order});

  @override
  List<Object?> get props => [order];
}

class UpdateOrderStatusEvent extends OrderEvent {
  final String orderId;
  final String status;
  const UpdateOrderStatusEvent({required this.orderId, required this.status});

  @override
  List<Object?> get props => [orderId, status];
}

class DeleteOrderEvent extends OrderEvent {
  final String orderId;
  const DeleteOrderEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

// States
abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrdersLoaded extends OrderState {
  final List<OrderEntity> orders;
  const OrdersLoaded({required this.orders});

  @override
  List<Object?> get props => [orders];
}

class OrderLoaded extends OrderState {
  final OrderEntity order;
  const OrderLoaded({required this.order});

  @override
  List<Object?> get props => [order];
}

class OrderCreated extends OrderState {
  final OrderEntity order;
  const OrderCreated({required this.order});

  @override
  List<Object?> get props => [order];
}

class OrderUpdated extends OrderState {
  final OrderEntity order;
  const OrderUpdated({required this.order});

  @override
  List<Object?> get props => [order];
}

class OrderDeleted extends OrderState {
  final String orderId;
  const OrderDeleted({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class OrderError extends OrderState {
  final String message;
  const OrderError({required this.message});

  @override
  List<Object?> get props => [message];
}

// ViewModel
class OrderViewModel extends Bloc<OrderEvent, OrderState> {
  final GetAllOrdersUseCase getAllOrdersUseCase;
  final GetOrderByIdUseCase getOrderByIdUseCase;
  final CreateOrderUseCase createOrderUseCase;
  final UpdateOrderStatusUseCase updateOrderStatusUseCase;
  final DeleteOrderUseCase deleteOrderUseCase;
  final UserSharedPrefs _userSharedPrefs;

  OrderViewModel({
    required this.getAllOrdersUseCase,
    required this.getOrderByIdUseCase,
    required this.createOrderUseCase,
    required this.updateOrderStatusUseCase,
    required this.deleteOrderUseCase,
    required UserSharedPrefs userSharedPrefs,
  }) : _userSharedPrefs = userSharedPrefs,
       super(OrderInitial()) {
    on<LoadAllOrdersEvent>(_onLoadAllOrders);
    on<LoadOrderByIdEvent>(_onLoadOrderById);
    on<CreateOrderEvent>(_onCreateOrder);
    on<UpdateOrderStatusEvent>(_onUpdateOrderStatus);
    on<DeleteOrderEvent>(_onDeleteOrder);
  }

  String _getUserId(String? eventUserId) {
    return eventUserId ?? _userSharedPrefs.getCurrentUserId() ?? 'unknown_user';
  }

  Future<void> _onLoadAllOrders(
    LoadAllOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    final userId = _getUserId(event.userId);
    print('🔍 OrderViewModel: Loading orders for userId: $userId');

    final result = await getAllOrdersUseCase(
      GetAllOrdersParams(userId: userId),
    );
    result.fold(
      (failure) {
        print('❌ OrderViewModel: Failed to load orders: ${failure.message}');
        emit(OrderError(message: failure.message));
      },
      (orders) {
        print('✅ OrderViewModel: Successfully loaded ${orders.length} orders');
        emit(OrdersLoaded(orders: orders));
      },
    );
  }

  Future<void> _onLoadOrderById(
    LoadOrderByIdEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    final result = await getOrderByIdUseCase(
      GetOrderByIdParams(orderId: event.orderId),
    );
    result.fold(
      (failure) => emit(OrderError(message: failure.message)),
      (order) => emit(OrderLoaded(order: order)),
    );
  }

  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    final result = await createOrderUseCase(
      CreateOrderParams(order: event.order),
    );
    result.fold(
      (failure) => emit(OrderError(message: failure.message)),
      (order) => emit(OrderCreated(order: order)),
    );
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatusEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    final result = await updateOrderStatusUseCase(
      UpdateOrderStatusParams(orderId: event.orderId, status: event.status),
    );
    result.fold(
      (failure) => emit(OrderError(message: failure.message)),
      (order) => emit(OrderUpdated(order: order)),
    );
  }

  Future<void> _onDeleteOrder(
    DeleteOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    final result = await deleteOrderUseCase(
      DeleteOrderParams(orderId: event.orderId),
    );
    result.fold(
      (failure) => emit(OrderError(message: failure.message)),
      (_) => emit(OrderDeleted(orderId: event.orderId)),
    );
  }
}
