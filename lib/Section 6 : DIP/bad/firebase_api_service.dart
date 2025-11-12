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

class ProfileManager {
  final FirebaseApiService _apiService = FirebaseApiService();

  Future<UserProfile> loadProfile(String userId) async {
    final data = await _apiService.getUserProfile(userId);
    return UserProfile(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      avatarUrl: data['avatar_url'],
    );
  }

  Future<void> updateProfile(UserProfile profile) async {
    await _apiService.updateUserProfile(profile.id, {
      'name': profile.name,
      'email': profile.email,
      'avatar_url': profile.avatarUrl,
    });
  }
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
  });
}

void main() async {
  final profileManager = ProfileManager();

  final profile = await profileManager.loadProfile('user123');
  print('Loaded profile: ${profile.name}');
}
