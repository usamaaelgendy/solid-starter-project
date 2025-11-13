import 'dart:convert';
import 'package:http/http.dart' as http;

class FirebaseApiService {
  final String baseUrl = 'https://myapp.firebaseio.com';

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId.json'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  Future<void> updateUserProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    await http.put(
      Uri.parse('$baseUrl/users/$userId.json'),
      body: json.encode(data),
    );
  }
}
