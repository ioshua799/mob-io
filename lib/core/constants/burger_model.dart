class Burger {
  final String id;
  final String title;
  final String description;
  final String price;
  final String imageUrl;
  final String category;

  Burger({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  factory Burger.fromJson(Map<String, dynamic> json) {
    return Burger(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      imageUrl: json['imageUrl'] ?? 'assets/images/g4.jpg', // fallback to local asset if needed
      category: json['category'] ?? 'All',
    );
  }
}