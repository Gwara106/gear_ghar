class Order {
  final String? id;
  final String? orderNumber;
  final String? userId;
  final List<OrderItem>? items;
  final double? subtotal;
  final double? tax;
  final double? shipping;
  final double? discount;
  final double? total;
  final String? currency;
  final String? status;
  final List<OrderStatus>? statusHistory;
  final String? shippingAddressId;
  final String? billingAddressId;
  final String? paymentMethodId;
  final String? paymentStatus;
  final String? paymentId;
  final String? trackingNumber;
  final String? carrier;
  final DateTime? estimatedDelivery;
  final DateTime? actualDelivery;
  final String? notes;
  final String? customerNotes;
  final String? promoCode;
  final bool? isGift;
  final String? giftMessage;
  final bool? giftWrap;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Order({
    this.id,
    this.orderNumber,
    this.userId,
    this.items,
    this.subtotal,
    this.tax,
    this.shipping,
    this.discount,
    this.total,
    this.currency,
    this.status,
    this.statusHistory,
    this.shippingAddressId,
    this.billingAddressId,
    this.paymentMethodId,
    this.paymentStatus,
    this.paymentId,
    this.trackingNumber,
    this.carrier,
    this.estimatedDelivery,
    this.actualDelivery,
    this.notes,
    this.customerNotes,
    this.promoCode,
    this.isGift,
    this.giftMessage,
    this.giftWrap,
    this.createdAt,
    this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      orderNumber: json['orderNumber']?.toString(),
      userId: json['user']?.toString() ?? json['userId']?.toString(),
      items: json['items'] != null 
          ? (json['items'] as List).map((item) => OrderItem.fromJson(item)).toList()
          : null,
      subtotal: (json['subtotal'] as num?)?.toDouble(),
      tax: (json['tax'] as num?)?.toDouble(),
      shipping: (json['shipping'] as num?)?.toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
      total: (json['total'] as num?)?.toDouble(),
      currency: json['currency']?.toString(),
      status: json['status']?.toString(),
      statusHistory: json['statusHistory'] != null
          ? (json['statusHistory'] as List).map((status) => OrderStatus.fromJson(status)).toList()
          : null,
      shippingAddressId: json['shippingAddress']?.toString(),
      billingAddressId: json['billingAddress']?.toString(),
      paymentMethodId: json['paymentMethod']?.toString(),
      paymentStatus: json['paymentStatus']?.toString(),
      paymentId: json['paymentId']?.toString(),
      trackingNumber: json['trackingNumber']?.toString(),
      carrier: json['carrier']?.toString(),
      estimatedDelivery: json['estimatedDelivery'] != null
          ? DateTime.parse(json['estimatedDelivery'])
          : null,
      actualDelivery: json['actualDelivery'] != null
          ? DateTime.parse(json['actualDelivery'])
          : null,
      notes: json['notes']?.toString(),
      customerNotes: json['customerNotes']?.toString(),
      promoCode: json['promoCode']?.toString(),
      isGift: json['isGift'] as bool?,
      giftMessage: json['giftMessage']?.toString(),
      giftWrap: json['giftWrap'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (orderNumber != null) 'orderNumber': orderNumber,
      if (userId != null) 'user': userId,
      if (items != null) 'items': items!.map((item) => item.toJson()).toList(),
      if (subtotal != null) 'subtotal': subtotal,
      if (tax != null) 'tax': tax,
      if (shipping != null) 'shipping': shipping,
      if (discount != null) 'discount': discount,
      if (total != null) 'total': total,
      if (currency != null) 'currency': currency,
      if (status != null) 'status': status,
      if (statusHistory != null) 'statusHistory': statusHistory!.map((status) => status.toJson()).toList(),
      if (shippingAddressId != null) 'shippingAddress': shippingAddressId,
      if (billingAddressId != null) 'billingAddress': billingAddressId,
      if (paymentMethodId != null) 'paymentMethod': paymentMethodId,
      if (paymentStatus != null) 'paymentStatus': paymentStatus,
      if (paymentId != null) 'paymentId': paymentId,
      if (trackingNumber != null) 'trackingNumber': trackingNumber,
      if (carrier != null) 'carrier': carrier,
      if (estimatedDelivery != null) 'estimatedDelivery': estimatedDelivery!.toIso8601String(),
      if (actualDelivery != null) 'actualDelivery': actualDelivery!.toIso8601String(),
      if (notes != null) 'notes': notes,
      if (customerNotes != null) 'customerNotes': customerNotes,
      if (promoCode != null) 'promoCode': promoCode,
      if (isGift != null) 'isGift': isGift,
      if (giftMessage != null) 'giftMessage': giftMessage,
      if (giftWrap != null) 'giftWrap': giftWrap,
    };
  }

  int get itemCount {
    if (items == null) return 0;
    return items!.fold(0, (sum, item) => sum + (item.quantity ?? 0));
  }

  String get formattedTotal {
    if (total == null) return '\$0.00';
    return '\$${total!.toStringAsFixed(2)}';
  }

  OrderStatus? get currentStatus {
    if (statusHistory == null || statusHistory!.isEmpty) {
      return OrderStatus(
        status: status ?? 'pending',
        timestamp: createdAt ?? DateTime.now(),
        note: 'Order created',
      );
    }
    return statusHistory!.last;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Order && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Order(id: $id, orderNumber: $orderNumber, status: $status, total: $formattedTotal)';
  }
}

class OrderItem {
  final String? itemId;
  final int? quantity;
  final double? price;
  final double? totalPrice;
  final String? itemName;
  final List<String>? itemImages;

  OrderItem({
    this.itemId,
    this.quantity,
    this.price,
    this.totalPrice,
    this.itemName,
    this.itemImages,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      itemId: json['item']?.toString() ?? json['itemId']?.toString(),
      quantity: json['quantity'] as int?,
      price: (json['price'] as num?)?.toDouble(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      itemName: json['item']?['name']?.toString() ?? json['itemName']?.toString(),
      itemImages: json['item']?['images'] != null
          ? (json['item']['images'] as List).map((img) => img.toString()).toList()
          : json['itemImages'] != null
              ? (json['itemImages'] as List).map((img) => img.toString()).toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (itemId != null) 'item': itemId,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
      if (totalPrice != null) 'totalPrice': totalPrice,
    };
  }

  @override
  String toString() {
    return 'OrderItem(itemId: $itemId, quantity: $quantity, price: $price, totalPrice: $totalPrice)';
  }
}

class OrderStatus {
  final String? status;
  final DateTime? timestamp;
  final String? note;

  OrderStatus({
    this.status,
    this.timestamp,
    this.note,
  });

  factory OrderStatus.fromJson(Map<String, dynamic> json) {
    return OrderStatus(
      status: json['status']?.toString(),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
      note: json['note']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (status != null) 'status': status,
      if (timestamp != null) 'timestamp': timestamp!.toIso8601String(),
      if (note != null) 'note': note,
    };
  }

  @override
  String toString() {
    return 'OrderStatus(status: $status, timestamp: $timestamp, note: $note)';
  }
}
