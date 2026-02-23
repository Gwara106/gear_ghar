class PaymentMethod {
  final String? id;
  final String? type;
  final String? cardType;
  final String? lastFour;
  final String? expiryMonth;
  final String? expiryYear;
  final String? cardholderName;
  final String? brand;
  final String? paypalEmail;
  final String? bankAccountType;
  final String? bankName;
  final String? bankLastFour;
  final bool? isDefault;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PaymentMethod({
    this.id,
    this.type,
    this.cardType,
    this.lastFour,
    this.expiryMonth,
    this.expiryYear,
    this.cardholderName,
    this.brand,
    this.paypalEmail,
    this.bankAccountType,
    this.bankName,
    this.bankLastFour,
    this.isDefault,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      type: json['type']?.toString(),
      cardType: json['cardType']?.toString(),
      lastFour: json['lastFour']?.toString(),
      expiryMonth: json['expiryMonth']?.toString(),
      expiryYear: json['expiryYear']?.toString(),
      cardholderName: json['cardholderName']?.toString(),
      brand: json['brand']?.toString(),
      paypalEmail: json['paypalEmail']?.toString(),
      bankAccountType: json['bankAccountType']?.toString(),
      bankName: json['bankName']?.toString(),
      bankLastFour: json['bankLastFour']?.toString(),
      isDefault: json['isDefault'] as bool?,
      isActive: json['isActive'] as bool?,
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
      if (type != null) 'type': type,
      if (cardType != null) 'cardType': cardType,
      if (lastFour != null) 'lastFour': lastFour,
      if (expiryMonth != null) 'expiryMonth': expiryMonth,
      if (expiryYear != null) 'expiryYear': expiryYear,
      if (cardholderName != null) 'cardholderName': cardholderName,
      if (brand != null) 'brand': brand,
      if (paypalEmail != null) 'paypalEmail': paypalEmail,
      if (bankAccountType != null) 'bankAccountType': bankAccountType,
      if (bankName != null) 'bankName': bankName,
      if (bankLastFour != null) 'bankLastFour': bankLastFour,
      if (isDefault != null) 'isDefault': isDefault,
      if (isActive != null) 'isActive': isActive,
    };
  }

  PaymentMethod copyWith({
    String? id,
    String? type,
    String? cardType,
    String? lastFour,
    String? expiryMonth,
    String? expiryYear,
    String? cardholderName,
    String? brand,
    String? paypalEmail,
    String? bankAccountType,
    String? bankName,
    String? bankLastFour,
    bool? isDefault,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      type: type ?? this.type,
      cardType: cardType ?? this.cardType,
      lastFour: lastFour ?? this.lastFour,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      cardholderName: cardholderName ?? this.cardholderName,
      brand: brand ?? this.brand,
      paypalEmail: paypalEmail ?? this.paypalEmail,
      bankAccountType: bankAccountType ?? this.bankAccountType,
      bankName: bankName ?? this.bankName,
      bankLastFour: bankLastFour ?? this.bankLastFour,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get expiryDate {
    if (expiryMonth == null || expiryYear == null) {
      return '';
    }
    return '$expiryMonth/$expiryYear';
  }

  String get displayText {
    switch (type) {
      case 'card':
        return '$cardType •••• ${lastFour ?? '----'}';
      case 'paypal':
        final email = paypalEmail;
        if (email != null && email.length >= 4) {
          return 'PayPal •••• ${email.substring(email.length - 4)}';
        }
        return 'PayPal •••• ----';
      case 'bank_account':
        return '$bankName •••• ${bankLastFour ?? '----'}';
      default:
        return 'Unknown Payment Method';
    }
  }

  bool get isExpired {
    if (type != 'card' || expiryMonth == null || expiryYear == null) {
      return false;
    }
    
    final now = DateTime.now();
    final expiryDate = DateTime(
      int.parse(expiryYear!),
      int.parse(expiryMonth!) + 1,
      0,
    );
    
    return now.isAfter(expiryDate);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentMethod && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'PaymentMethod(id: $id, type: $type, displayText: $displayText, isDefault: $isDefault)';
  }
}
