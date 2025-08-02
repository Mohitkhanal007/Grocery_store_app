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

  // Convert to JSON for backend API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'amount': amount,
      'method': _getMethodString(method),
      'status': _getStatusString(status),
      'transactionId': transactionId,
      'referenceId': referenceId,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'failureReason': failureReason,
    };
  }

  // Create from JSON from backend API
  factory PaymentEntity.fromJson(Map<String, dynamic> json) {
    return PaymentEntity(
      id: json['id'],
      orderId: json['orderId'],
      amount: json['amount'].toDouble(),
      method: _getMethodFromString(json['method']),
      status: _getStatusFromString(json['status']),
      transactionId: json['transactionId'],
      referenceId: json['referenceId'],
      customerName: json['customerName'],
      customerEmail: json['customerEmail'],
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      failureReason: json['failureReason'],
    );
  }

  // Helper methods for JSON conversion
  static String _getMethodString(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.esewa:
        return 'esewa';
      case PaymentMethod.cashOnDelivery:
        return 'cash_on_delivery';
    }
  }

  static PaymentMethod _getMethodFromString(String method) {
    switch (method) {
      case 'esewa':
        return PaymentMethod.esewa;
      case 'cash_on_delivery':
        return PaymentMethod.cashOnDelivery;
      default:
        return PaymentMethod.esewa;
    }
  }

  static String _getStatusString(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return 'pending';
      case PaymentStatus.processing:
        return 'processing';
      case PaymentStatus.completed:
        return 'completed';
      case PaymentStatus.failed:
        return 'failed';
      case PaymentStatus.cancelled:
        return 'cancelled';
    }
  }

  static PaymentStatus _getStatusFromString(String status) {
    switch (status) {
      case 'pending':
        return PaymentStatus.pending;
      case 'processing':
        return PaymentStatus.processing;
      case 'completed':
        return PaymentStatus.completed;
      case 'failed':
        return PaymentStatus.failed;
      case 'cancelled':
        return PaymentStatus.cancelled;
      default:
        return PaymentStatus.pending;
    }
  }

  // Business logic methods
  bool get isCompleted => status == PaymentStatus.completed;
  bool get isPending => status == PaymentStatus.pending;
  bool get isProcessing => status == PaymentStatus.processing;
  bool get isFailed => status == PaymentStatus.failed;
  bool get isCancelled => status == PaymentStatus.cancelled;

  // Get formatted amount
  String get formattedAmount => 'रू${amount.toStringAsFixed(2)}';

  // Get payment method display name
  String get methodDisplayName {
    switch (method) {
      case PaymentMethod.esewa:
        return 'eSewa';
      case PaymentMethod.cashOnDelivery:
        return 'Cash on Delivery';
    }
  }

  // Get status display name
  String get statusDisplayName {
    switch (status) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.processing:
        return 'Processing';
      case PaymentStatus.completed:
        return 'Completed';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.cancelled:
        return 'Cancelled';
    }
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
