// lib/models/user_model.dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? location;
  final String? avatarUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.location,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      location: json['location'],
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'avatarUrl': avatarUrl,
    };
  }
}

// lib/models/delivery_list_model.dart
class DeliveryListModel {
  final String id;
  final String name;
  final int itemCount;
  final String type; // 'UNIVERSAL', 'CUSTOM', etc.

  const DeliveryListModel({
    required this.id,
    required this.name,
    required this.itemCount,
    required this.type,
  });

  factory DeliveryListModel.fromJson(Map<String, dynamic> json) {
    return DeliveryListModel(
      id: json['id'],
      name: json['name'],
      itemCount: json['itemCount'] ?? 0,
      type: json['type'] ?? 'CUSTOM',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'itemCount': itemCount,
      'type': type,
    };
  }
}

// lib/models/delivery_item_model.dart
class DeliveryItemModel {
  final String id;
  final String name;
  final String? description;
  final String? category;
  final bool isCompleted;

  const DeliveryItemModel({
    required this.id,
    required this.name,
    this.description,
    this.category,
    this.isCompleted = false,
  });

  factory DeliveryItemModel.fromJson(Map<String, dynamic> json) {
    return DeliveryItemModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'isCompleted': isCompleted,
    };
  }

  DeliveryItemModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    bool? isCompleted,
  }) {
    return DeliveryItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}