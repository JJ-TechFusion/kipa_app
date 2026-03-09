import '../../domain/entities/transaction_status_entities.dart';

class TransactionStatusModel {
  final String id;
  final String status;
  final String viewerRole;
  final String itemName;
  final String itemDescription;
  final double itemPrice;
  final String deliveryType;
  final int processingTimeHours;
  final DateTime createdAt;
  final FeeInfoModel feeInfo;
  final PaymentInfoModel payment;
  final UserInfoModel seller;
  final UserInfoModel buyer;
  final TransactionTimelineModel timeline;
  final String? deliveryJobId;
  final String? pickupAddress;
  final String? dropoffAddress;
  final double? pickupLat;
  final double? pickupLng;
  final double? dropoffLat;
  final double? dropoffLng;

  const TransactionStatusModel({
    required this.id,
    required this.status,
    required this.viewerRole,
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
    required this.deliveryType,
    required this.processingTimeHours,
    required this.createdAt,
    required this.feeInfo,
    required this.payment,
    required this.seller,
    required this.buyer,
    required this.timeline,
    this.deliveryJobId,
    this.pickupAddress,
    this.dropoffAddress,
    this.pickupLat,
    this.pickupLng,
    this.dropoffLat,
    this.dropoffLng,
  });

  factory TransactionStatusModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    double? parseNullableDouble(dynamic value) {
      if (value == null) return null;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      if (value is String) return double.tryParse(value);
      return null;
    }

    final delivery = json['delivery'] as Map<String, dynamic>?;

    return TransactionStatusModel(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      viewerRole: json['viewer_role']?.toString() ?? '',
      itemName: json['item_name']?.toString() ?? '',
      itemDescription: json['item_description']?.toString() ?? '',
      itemPrice: parseDouble(json['item_price']),
      deliveryType: json['delivery_type']?.toString() ?? '',
      processingTimeHours: json['processing_time_hours'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      feeInfo: FeeInfoModel.fromJson(
        json['fee_info'] as Map<String, dynamic>? ?? {},
      ),
      payment: PaymentInfoModel.fromJson(
        json['payment'] as Map<String, dynamic>? ?? {},
      ),
      seller: UserInfoModel.fromJson(
        json['seller'] as Map<String, dynamic>? ?? {},
      ),
      buyer: UserInfoModel.fromJson(
        json['buyer'] as Map<String, dynamic>? ?? {},
      ),
      timeline: TransactionTimelineModel.fromJson(
        json['timeline'] as Map<String, dynamic>? ?? {},
      ),
      deliveryJobId:
          json['delivery_job_id']?.toString() ??
          delivery?['job_id']?.toString(),
      pickupAddress: delivery?['pickup_address']?.toString(),
      dropoffAddress: delivery?['dropoff_address']?.toString(),
      pickupLat: parseNullableDouble(delivery?['pickup_lat']),
      pickupLng: parseNullableDouble(delivery?['pickup_lng']),
      dropoffLat: parseNullableDouble(delivery?['dropoff_lat']),
      dropoffLng: parseNullableDouble(delivery?['dropoff_lng']),
    );
  }

  TransactionStatusEntity toEntity() {
    return TransactionStatusEntity(
      id: id,
      status: status,
      viewerRole: viewerRole,
      itemName: itemName,
      itemDescription: itemDescription,
      itemPrice: itemPrice,
      deliveryType: deliveryType,
      processingTimeHours: processingTimeHours,
      createdAt: createdAt,
      feeInfo: feeInfo.toEntity(),
      payment: payment.toEntity(),
      seller: seller.toEntity(),
      buyer: buyer.toEntity(),
      timeline: timeline.toEntity(),
      deliveryJobId: deliveryJobId,
      pickupAddress: pickupAddress,
      dropoffAddress: dropoffAddress,
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      dropoffLat: dropoffLat,
      dropoffLng: dropoffLng,
    );
  }
}

class FeeInfoModel {
  final double estimatedDeliveryFee;
  final double? serviceFee;
  final double? platformFee;
  final double buyerPaysTotal;
  final double? youReceive;

  const FeeInfoModel({
    required this.estimatedDeliveryFee,
    this.serviceFee,
    this.platformFee,
    required this.buyerPaysTotal,
    this.youReceive,
  });

  factory FeeInfoModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return FeeInfoModel(
      estimatedDeliveryFee: parseDouble(json['estimated_delivery_fee']),
      serviceFee: json['service_fee'] != null
          ? parseDouble(json['service_fee'])
          : null,
      platformFee: json['platform_fee'] != null
          ? parseDouble(json['platform_fee'])
          : null,
      buyerPaysTotal: parseDouble(json['buyer_pays_total']),
      youReceive: json['you_receive'] != null
          ? parseDouble(json['you_receive'])
          : null,
    );
  }

  FeeInfoEntity toEntity() {
    return FeeInfoEntity(
      estimatedDeliveryFee: estimatedDeliveryFee,
      serviceFee: serviceFee,
      platformFee: platformFee,
      buyerPaysTotal: buyerPaysTotal,
      youReceive: youReceive,
    );
  }
}

class PaymentInfoModel {
  final bool isPaid;
  final double amount;
  final String paymentMethod;
  final DateTime? paidAt;

  const PaymentInfoModel({
    required this.isPaid,
    required this.amount,
    required this.paymentMethod,
    this.paidAt,
  });

  factory PaymentInfoModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return PaymentInfoModel(
      isPaid: json['is_paid'] as bool? ?? false,
      amount: parseDouble(json['amount']),
      paymentMethod: json['payment_method']?.toString() ?? '',
      paidAt: json['paid_at'] != null
          ? DateTime.tryParse(json['paid_at'].toString())
          : null,
    );
  }

  PaymentInfoEntity toEntity() {
    return PaymentInfoEntity(
      isPaid: isPaid,
      amount: amount,
      paymentMethod: paymentMethod,
      paidAt: paidAt,
    );
  }
}

class UserInfoModel {
  final String id;
  final String name;
  final String phoneNumber;

  const UserInfoModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
    );
  }

  UserInfoEntity toEntity() {
    return UserInfoEntity(id: id, name: name, phoneNumber: phoneNumber);
  }
}

class TransactionTimelineModel {
  final List<TransactionTimelineStepModel> steps;
  final String currentStep;
  final String itemName;
  final double totalAmount;
  final String deliveryType;

  const TransactionTimelineModel({
    required this.steps,
    required this.currentStep,
    required this.itemName,
    required this.totalAmount,
    required this.deliveryType,
  });

  factory TransactionTimelineModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return TransactionTimelineModel(
      steps:
          (json['steps'] as List<dynamic>?)
              ?.map(
                (e) => TransactionTimelineStepModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      currentStep: json['current_step']?.toString() ?? '',
      itemName: json['item_name']?.toString() ?? '',
      totalAmount: parseDouble(json['total_amount']),
      deliveryType: json['delivery_type']?.toString() ?? '',
    );
  }

  TransactionTimelineEntity toEntity() {
    return TransactionTimelineEntity(
      steps: steps.map((e) => e.toEntity()).toList(),
      currentStep: currentStep,
      itemName: itemName,
      totalAmount: totalAmount,
      deliveryType: deliveryType,
    );
  }
}

class TransactionTimelineStepModel {
  final String step;
  final String title;
  final String description;
  final String status;
  final DateTime? timestamp;

  const TransactionTimelineStepModel({
    required this.step,
    required this.title,
    required this.description,
    required this.status,
    this.timestamp,
  });

  factory TransactionTimelineStepModel.fromJson(Map<String, dynamic> json) {
    return TransactionTimelineStepModel(
      step: json['step']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString())
          : null,
    );
  }

  TransactionTimelineStepEntity toEntity() {
    return TransactionTimelineStepEntity(
      step: step,
      title: title,
      description: description,
      status: status,
      timestamp: timestamp,
    );
  }
}
