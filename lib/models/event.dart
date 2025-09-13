// lib/models/event.dart
class Event {
  final String id;
  final String name;
  final String description;
  final DateTime date;
  final String location;
  final bool isActive;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.location,
    this.isActive = true,
  });

  Event copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? date,
    String? location,
    bool? isActive,
  }) {
    return Event(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      date: date ?? this.date,
      location: location ?? this.location,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
      'isActive': isActive,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      location: json['location'],
      isActive: json['isActive'] ?? true,
    );
  }
}

// lib/models/food_item.dart
class FoodItem {
  final String id;
  final String name;
  final String unit;

  final bool isShow;

  FoodItem({
    required this.id,
    required this.name,
    required this.unit,

    this.isShow = true,
  });

  FoodItem copyWith({
    String? id,
    String? name,
    String? unit,
    double? defaultQty,
    bool? isShow,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      unit: unit ?? this.unit,

      isShow: isShow ?? this.isShow,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'unit': unit,

      'isShow': isShow,
    };
  }

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      name: json['name'],
      unit: json['unit'],
      isShow: json['isShow'] ?? true,
    );
  }
}

// lib/models/pradesh.dart
class Pradesh {
  final String id;
  final String name;
  final String gujName;
  final String oldPradeshName;
  final String oldGujPradeshName;
  final bool isActive;

  Pradesh({
    required this.id,
    required this.name,
    required this.gujName,
    required this.oldPradeshName,
    required this.oldGujPradeshName,
    this.isActive = true,
  });

  Pradesh copyWith({
    String? id,
    String? name,
    String? gujName,
    String? oldPradeshName,
    String? oldGujPradeshName,
    bool? isActive,
  }) {
    return Pradesh(
      id: id ?? this.id,
      name: name ?? this.name,
      gujName: gujName ?? this.gujName,
      oldPradeshName: oldPradeshName ?? this.oldPradeshName,
      oldGujPradeshName: oldGujPradeshName ?? this.oldGujPradeshName,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gujName': gujName,
      'oldPradeshName': oldPradeshName,
      'oldGujPradeshName': oldGujPradeshName,
      'isActive': isActive,
    };
  }

  factory Pradesh.fromJson(Map<String, dynamic> json) {
    return Pradesh(
      id: json['id'],
      name: json['name'],
      gujName: json['gujName'],
      oldPradeshName: json['oldPradeshName'],
      oldGujPradeshName: json['oldGujPradeshName'],
      isActive: json['isActive'] ?? true,
    );
  }
}


// lib/models/user.dart
class User {
  final String id;
  final String name;

  final String phone;
  final String role;
  final String? pradeshName; // ✅ Added Pradesh Name
  final bool isActive;

  User({
    required this.id,
    required this.name,

    required this.phone,
    required this.role,
    this.pradeshName, // optional
    this.isActive = true,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? pradeshName,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,

      phone: phone ?? this.phone,
      role: role ?? this.role,
      pradeshName: pradeshName ?? this.pradeshName,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'role': role,
      'pradeshName': pradeshName,
      'isActive': isActive,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      role: json['role'],
      pradeshName: json['pradeshName'], // ✅ Parse Pradesh Name
      isActive: json['isActive'] ?? true,
    );
  }
}
