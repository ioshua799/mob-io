import '../constants/burger_model.dart';

class StoreCatalogService {
  const StoreCatalogService();

  static const List<Map<String, String>> _catalogItems = [
    {
      'title': 'The Station Classic',
      'description': 'Double beef, cheese, station sauce...',
      'price': '\$18.00',
      'image': 'assets/images/station_classic.webp',
      'category': 'Beef',
    },
    {
      'title': 'Spicy Jalapeno Burger',
      'description': 'Crispy chicken, hot sauce, kitchen...',
      'price': '\$13.00',
      'image': 'assets/images/spicy_jalapeno.webp',
      'category': 'Chicken',
    },
    {
      'title': 'Beyond Station Veggie',
      'description': 'Crispy chicken, cheese, station sauce...',
      'price': '\$13.00',
      'image': 'assets/images/station_veggie.jpg',
      'category': 'Veggie',
    },
    {
      'title': 'G4',
      'description': 'Spicy smashburger with double beef patties, pepper jack cheese.',
      'price': '\$14.50',
      'image': 'assets/images/g4.jpg',
      'category': 'Beef',
    },
    {
      'title': 'MCdoo',
      'description': 'Spicy chicken burger with crispy fried chicken fillet, spicy mayo.',
      'price': '\$12.00',
      'image': 'assets/images/mcdoo.jpg',
      'category': 'Chicken',
    },
  ];

  List<Burger> getCatalog({List<Map<String, dynamic>> apiItems = const []}) {
    return List.generate(_catalogItems.length, (index) {
      final item = _catalogItems[index];
      final apiItem = apiItems.isEmpty ? null : apiItems[index % apiItems.length];

      return Burger(
        id: apiItem?['id']?.toString() ?? '${index + 1}',
        title: item['title']!,
        description: item['description']!,
        price: item['price']!,
        imageUrl: item['image']!,
        category: item['category']!,
      );
    });
  }
}