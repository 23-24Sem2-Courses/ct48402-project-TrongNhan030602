class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;
  final String author;
  final DateTime publishedDate;
  final String category;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    required this.imageUrl,
    required this.author,
    required this.publishedDate,
    required this.category,
  });

  CartItem copyWith({
    String? id,
    String? title,
    int? quantity,
    double? price,
    String? imageUrl,
    String? author,
    DateTime? publishedDate,
    String? category,
  }) {
    return CartItem(
      id: id ?? this.id,
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      author: author ?? this.author,
      publishedDate: publishedDate ?? this.publishedDate,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
      'author': author,
      'publishedDate': publishedDate.toIso8601String(),
      'category': category,
    };
  }

  static CartItem fromJson(String key, Map<String, dynamic> json) {
    try {
      return CartItem(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        quantity: json['quantity'] ?? 0,
        price: json['price'] ?? 0.0,
        imageUrl: json['imageUrl'] ?? '',
        author: json['author'] ?? '',
        publishedDate: json['publishedDate'] != null
            ? DateTime.parse(json['publishedDate'])
            : DateTime.now(),
        category: json['category'] ?? '',
      );
    } catch (error) {
      print('Error parsing CartItem from JSON: $error');
      throw FormatException('Invalid CartItem JSON format');
    }
  }
}
