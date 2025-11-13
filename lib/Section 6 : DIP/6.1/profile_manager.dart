import 'package:solid_examples/Section%206%20:%20DIP/6.1/firebase_api_service.dart';
import 'package:solid_examples/Section%206%20:%20DIP/6.1/user_profile.dart';

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
