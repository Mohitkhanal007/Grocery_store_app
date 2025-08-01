import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jerseyhub/features/payment/domain/entity/payment_entity.dart';
import 'package:jerseyhub/features/payment/domain/use_case/create_payment_usecase.dart';

// Events
abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class CreatePaymentEvent extends PaymentEvent {
  final PaymentRequestEntity request;

  const CreatePaymentEvent({required this.request});

  @override
  List<Object?> get props => [request];
}

class VerifyPaymentEvent extends PaymentEvent {
  final String orderId;
  final String amount;
  final String referenceId;
  final String signature;

  const VerifyPaymentEvent({
    required this.orderId,
    required this.amount,
    required this.referenceId,
    required this.signature,
  });

  @override
  List<Object?> get props => [orderId, amount, referenceId, signature];
}

class GetPaymentStatusEvent extends PaymentEvent {
  final String orderId;

  const GetPaymentStatusEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

// States
abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentCreated extends PaymentState {
  final PaymentResponseEntity response;

  const PaymentCreated({required this.response});

  @override
  List<Object?> get props => [response];
}

class PaymentVerified extends PaymentState {
  final PaymentEntity payment;

  const PaymentVerified({required this.payment});

  @override
  List<Object?> get props => [payment];
}

class PaymentStatusLoaded extends PaymentState {
  final PaymentEntity payment;

  const PaymentStatusLoaded({required this.payment});

  @override
  List<Object?> get props => [payment];
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError({required this.message});

  @override
  List<Object?> get props => [message];
}

// ViewModel
class PaymentViewModel extends Bloc<PaymentEvent, PaymentState> {
  final CreatePaymentUseCase createPaymentUseCase;

  PaymentViewModel({required this.createPaymentUseCase})
    : super(PaymentInitial()) {
    on<CreatePaymentEvent>(_onCreatePayment);
    on<VerifyPaymentEvent>(_onVerifyPayment);
    on<GetPaymentStatusEvent>(_onGetPaymentStatus);
  }

  Future<void> _onCreatePayment(
    CreatePaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    print('🔄 PaymentViewModel: Starting payment creation...');
    emit(PaymentLoading());

    final result = await createPaymentUseCase(event.request);

    result.fold(
      (failure) {
        print('❌ PaymentViewModel: Payment failed - ${failure.message}');
        emit(PaymentError(message: failure.message));
      },
      (response) {
        print('✅ PaymentViewModel: Payment created successfully');
        emit(PaymentCreated(response: response));
      },
    );
  }

  Future<void> _onVerifyPayment(
    VerifyPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    // TODO: Implement verify payment use case
    emit(const PaymentError(message: 'Verify payment not implemented yet'));
  }

  Future<void> _onGetPaymentStatus(
    GetPaymentStatusEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    // TODO: Implement get payment status use case
    emit(const PaymentError(message: 'Get payment status not implemented yet'));
  }
}
