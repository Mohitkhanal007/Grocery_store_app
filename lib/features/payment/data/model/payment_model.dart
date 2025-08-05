import 'package:equatable/equatable.dart';
import 'package:grocerystore/features/payment/domain/entity/payment_entity.dart';

class PaymentModel extends Equatable {
  final String id;
  final String orderId;
  final double amount;
  final String methodString;
  final String statusString;
  final String? transactionId;
  final String? referenceId;
  final String? customerName;
  final String? customerEmail;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? failureReason;

  const PaymentModel({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.methodString,
    required this.statusString,
    this.transactionId,
    this.referenceId,
    this.customerName,
    this.customerEmail,
    required this.createdAt,
    this.completedAt,
    this.failureReason,
  });

  PaymentMethod get method {
    switch (methodString.toLowerCase()) {
      case 'esewa':
        return PaymentMethod.esewa;
      case 'cash_on_delivery':
      case 'cashondelivery':
        return PaymentMethod.cashOnDelivery;
      default:
        return PaymentMethod.esewa;
    }
  }

  PaymentStatus get status {
    switch (statusString.toLowerCase()) {
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

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['_id'] ?? json['id'] ?? '',
      orderId: json['orderId'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      methodString: json['method'] ?? 'esewa',
      statusString: json['status'] ?? 'pending',
      transactionId: json['transactionId'],
      referenceId: json['referenceId'],
      customerName: json['customerName'],
      customerEmail: json['customerEmail'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      failureReason: json['failureReason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'amount': amount,
      'method': methodString,
      'status': statusString,
      'transactionId': transactionId,
      'referenceId': referenceId,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'failureReason': failureReason,
    };
  }

  PaymentEntity toEntity() {
    return PaymentEntity(
      id: id,
      orderId: orderId,
      amount: amount,
      method: method,
      status: status,
      transactionId: transactionId,
      referenceId: referenceId,
      customerName: customerName,
      customerEmail: customerEmail,
      createdAt: createdAt,
      completedAt: completedAt,
      failureReason: failureReason,
    );
  }

  @override
  List<Object?> get props => [
    id,
    orderId,
    amount,
    methodString,
    statusString,
    transactionId,
    referenceId,
    customerName,
    customerEmail,
    createdAt,
    completedAt,
    failureReason,
  ];
}

class PaymentRequestModel extends Equatable {
  final String orderId;
  final double amount;
  final String customerName;
  final String customerEmail;
  final String methodString;

  const PaymentRequestModel({
    required this.orderId,
    required this.amount,
    required this.customerName,
    required this.customerEmail,
    required this.methodString,
  });

  PaymentMethod get method {
    switch (methodString.toLowerCase()) {
      case 'esewa':
        return PaymentMethod.esewa;
      case 'cash_on_delivery':
      case 'cashondelivery':
        return PaymentMethod.cashOnDelivery;
      default:
        return PaymentMethod.esewa;
    }
  }

  factory PaymentRequestModel.fromJson(Map<String, dynamic> json) {
    return PaymentRequestModel(
      orderId: json['orderId'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      customerName: json['customerName'] ?? '',
      customerEmail: json['customerEmail'] ?? '',
      methodString: json['method'] ?? 'esewa',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'amount': amount,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'method': methodString,
    };
  }

  PaymentRequestEntity toEntity() {
    return PaymentRequestEntity(
      orderId: orderId,
      amount: amount,
      customerName: customerName,
      customerEmail: customerEmail,
      method: method,
    );
  }

  @override
  List<Object?> get props => [
    orderId,
    amount,
    customerName,
    customerEmail,
    methodString,
  ];
}

class PaymentResponseModel extends Equatable {
  final bool success;
  final String? paymentUrl;
  final String? transactionId;
  final String? message;
  final String? error;

  const PaymentResponseModel({
    required this.success,
    this.paymentUrl,
    this.transactionId,
    this.message,
    this.error,
  });

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentResponseModel(
      success: json['success'] ?? false,
      paymentUrl: json['paymentUrl'] ?? json['url'],
      transactionId: json['transactionId'],
      message: json['message'],
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'paymentUrl': paymentUrl,
      'transactionId': transactionId,
      'message': message,
      'error': error,
    };
  }

  PaymentResponseEntity toEntity() {
    return PaymentResponseEntity(
      success: success,
      paymentUrl: paymentUrl,
      transactionId: transactionId,
      message: message,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    success,
    paymentUrl,
    transactionId,
    message,
    error,
  ];
}
