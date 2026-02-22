class Address {
  final String? id;
  final String? name;
  final String? customName;
  final String? streetAddress;
  final String? apartment;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;
  final String? phoneNumber;
  final bool? isDefault;
  final double? latitude;
  final double? longitude;
  final String? deliveryInstructions;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Address({
    this.id,
    this.name,
    this.customName,
    this.streetAddress,
    this.apartment,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    this.phoneNumber,
    this.isDefault,
    this.latitude,
    this.longitude,
    this.deliveryInstructions,
    this.createdAt,
    this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      name: json['name']?.toString(),
      customName: json['customName']?.toString(),
      streetAddress: json['streetAddress']?.toString(),
      apartment: json['apartment']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      postalCode: json['postalCode']?.toString(),
      country: json['country']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      isDefault: json['isDefault'] as bool?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      deliveryInstructions: json['deliveryInstructions']?.toString(),
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
      if (name != null) 'name': name,
      if (customName != null) 'customName': customName,
      if (streetAddress != null) 'streetAddress': streetAddress,
      if (apartment != null) 'apartment': apartment,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (postalCode != null) 'postalCode': postalCode,
      if (country != null) 'country': country,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (isDefault != null) 'isDefault': isDefault,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (deliveryInstructions != null) 'deliveryInstructions': deliveryInstructions,
    };
  }

  Address copyWith({
    String? id,
    String? name,
    String? customName,
    String? streetAddress,
    String? apartment,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    String? phoneNumber,
    bool? isDefault,
    double? latitude,
    double? longitude,
    String? deliveryInstructions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Address(
      id: id ?? this.id,
      name: name ?? this.name,
      customName: customName ?? this.customName,
      streetAddress: streetAddress ?? this.streetAddress,
      apartment: apartment ?? this.apartment,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isDefault: isDefault ?? this.isDefault,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get displayName {
    if (name == 'Other' && customName != null && customName!.isNotEmpty) {
      return customName!;
    }
    return name ?? 'Unknown';
  }

  String get fullAddress {
    String address = streetAddress ?? '';
    if (apartment != null && apartment!.isNotEmpty) {
      address += ', $apartment';
    }
    if (city != null && state != null && postalCode != null) {
      address += '\n$city, $state $postalCode';
    }
    if (country != null) {
      address += '\n$country';
    }
    return address;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Address && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Address(id: $id, name: $name, streetAddress: $streetAddress, city: $city, isDefault: $isDefault)';
  }
}
