import 'dart:convert';

class Rating {
  double rate;
  int count;

  Rating({required this.rate, required this.count});

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      rate: (map['rate'] as num).toDouble(),
      count: (map['count'] as num).toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rate': rate,
      'count': count,
    };
  }
}

class ProductModel {
  int id;
  String title;
  double price;
  String description;
  String category;
  String image;
  Rating? rating;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.rating,
  });

  ProductModel copyWith({
    int? id,
    String? title,
    double? price,
    String? description,
    String? category,
    String? image,
    Rating? rating,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': rating?.toMap(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: (map['id'] as num).toInt(),
      title: map['title'] ?? '',
      price: (map['price'] as num).toDouble(),
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      image: map['image'] ?? '',
      rating: map['rating'] != null ? Rating.fromMap(map['rating']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductModel(id: $id, title: $title, price: $price, description: $description, category: $category, image: $image, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductModel &&
        other.id == id &&
        other.title == title &&
        other.price == price &&
        other.description == description &&
        other.category == category &&
        other.image == image &&
        other.rating == rating;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        price.hashCode ^
        description.hashCode ^
        category.hashCode ^
        image.hashCode ^
        rating.hashCode;
  }
}
