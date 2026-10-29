import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiController {
  static final Uri postsUri = Uri.parse(
    'https://jsonplaceholder.typicode.com/posts?_limit=5',
  );

  Future<List<Map<String, dynamic>>> getPosts() async {
    final response = await http.get(postsUri);

    if (response.statusCode != 200) {
      throw Exception('GET request failed with status ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const FormatException('Expected the API response to be a JSON array.');
    }

    return decoded
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList(growable: false);
  }
}