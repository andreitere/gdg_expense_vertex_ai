class UserProfile {
  final String photo;
  final String email;
  final int userId;

  UserProfile({required this.photo, required this.email, required this.userId});

  // Factory constructor to create a UserProfile instance from a JSON map
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      photo: json['profile_picture_url'] ?? '',
      email: json['email'] ?? '',
      userId: json['userId'] ?? -1,
    );
  }

  // Method to convert a UserProfile instance into a JSON map
  Map<String, dynamic> toJson() {
    return {'profile_picture_url': photo, 'email': email, 'user_id': userId};
  }
}

class UserGroup {
  final String title;
  final String category;
  final String? photo; // Nullable since photo can be null
  final String description;
  final int groupId;

  UserGroup({
    required this.groupId,
    required this.title,
    required this.category,
    this.photo,
    required this.description,
  });

  // Factory constructor to create an instance from a JSON map
  factory UserGroup.fromJson(Map<String, dynamic> json) {
    return UserGroup(
      groupId: json["group_id"] as int,
      title: json['title'] as String,
      category: json['category'] as String,
      photo: json['photo'] as String?, // Handle null for photo
      description: json['description'] as String,
    );
  }

  // Method to convert an instance of Activity to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'group_id': groupId,
      'title': title,
      'category': category,
      'photo': photo,
      'description': description,
    };
  }
}

class ExpenseItem {
  final String title;
  final double price;
  final double quantity;

  ExpenseItem({
    required this.price,
    required this.quantity,
    required this.title,
  });

  factory ExpenseItem.fromJson(Map<String, dynamic> json) {
    return ExpenseItem(
      price: json['price'].toDouble(),
      quantity: json['quantity'].toDouble(),
      title: json['title'],
    );
  }
}

class ExpensesReceipt {
  final List<ExpenseItem> items;
  final double total;

  ExpensesReceipt({required this.items, required this.total});

  factory ExpensesReceipt.fromJson(Map<String, dynamic> json) {
    List<ExpenseItem> parsedItems = (json['items'] as List<dynamic>).map((itemJson) => ExpenseItem.fromJson(itemJson)).toList();
    return ExpensesReceipt(
      items: parsedItems,
      total: json['total'].toDouble(),
    );
  }
}

class CreatedGroup {
  final int groupId;

  CreatedGroup({required this.groupId});

  // Factory constructor to create a Group instance from a JSON map
  factory CreatedGroup.fromJson(Map<String, dynamic> json) {
    return CreatedGroup(
      groupId: json['group_id'] as int,
    );
  }

  // Method to convert a Group instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'group_id': groupId,
    };
  }
}
