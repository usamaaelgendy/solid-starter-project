import 'package:solid_examples/Section%206%20:%20DIP/6.3/services/analytics_service.dart';
import 'package:solid_examples/Section%206%20:%20DIP/6.3/services/api_service.dart';
import 'package:solid_examples/Section%206%20:%20DIP/6.3/services/auth_service.dart';

class ProfileService {
  final AuthService authService;
  final ApiService apiService;
  final AnalyticsService analyticsService;

  ProfileService({
    required this.authService,
    required this.apiService,
    required this.analyticsService,
  });

  Future<void> loadProfile() async {
    final userId = authService.getCurrentUserId();
    if (userId != null) {
      final posts = await apiService.fetchUserPosts(userId);
      print('Loaded ${posts.length} posts');
      analyticsService.logEvent('posts_loaded');
    }
  }
}
