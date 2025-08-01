import 'package:equatable/equatable.dart';

enum PaymentStatus { pending, processing, completed, failed, cancelled }

enum PaymentMethod { esewa, cashOnDelivery }

class PaymentEntity extends Equatable {
  final String id;
  final String orderId;
  final double amount;
  final PaymentMethod method;
  final PaymentStatus status;
  final String? transactionId;
  final String? referenceId;
  final String? customerName;
  final String? customerEmail;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? failureReason;

  const PaymentEntity({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.method,
    required this.status,
    this.transactionId,
    this.referenceId,
    this.customerName,
    this.customerEmail,
    required this.createdAt,
    this.completedAt,
    this.failureReason,
  });

  @override
  List<Object?> get props => [
    id,
    orderId,
    amount,
    method,
    status,
    transactionId,
    referenceId,
    customerName,
    customerEmail,
    createdAt,
    completedAt,
    failureReason,
  ];

  PaymentEntity copyWith({
    String? id,
    String? orderId,
    double? amount,
    PaymentMethod? method,
    PaymentStatus? status,
    String? transactionId,
    String? referenceId,
    String? customerName,
    String? customerEmail,
    DateTime? createdAt,
    DateTime? completedAt,
    String? failureReason,
  }) {
    return PaymentEntity(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      status: status ?? this.status,
      transactionId: transactionId ?? this.transactionId,
      referenceId: referenceId ?? this.referenceId,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      failureReason: failureReason ?? this.failureReason,
    );
  }
}

class PaymentRequestEntity extends Equatable {
  final String orderId;
  final double amount;
  final String customerName;
  final String customerEmail;
  final PaymentMethod method;

  const PaymentRequestEntity({
    required this.orderId,
    required this.amount,
    required this.customerName,
    required this.customerEmail,
    required this.method,
  });

  @override
  List<Object?> get props => [
    orderId,
    amount,
    customerName,
    customerEmail,
    method,
  ];
}

class PaymentResponseEntity extends Equatable {
  final bool success;
  final String? paymentUrl;
  final String? transactionId;
  final String? message;
  final String? error;

  const PaymentResponseEntity({
    required this.success,
    this.paymentUrl,
    this.transactionId,
    this.message,
    this.error,
  });

  @override
  List<Object?> get props => [
    success,
    paymentUrl,
    transactionId,
    message,
    error,
  ];
}
