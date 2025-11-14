import 'package:solid_examples/Section%206%20:%20DIP/6.3/services/analytics_service.dart';
import 'package:solid_examples/Section%206%20:%20DIP/6.3/services/api_service.dart';
import 'package:solid_examples/Section%206%20:%20DIP/6.3/services/auth_service.dart';
import 'package:solid_examples/Section%206%20:%20DIP/6.3/services/profile_service.dart';

class UserModule {
  final AuthService authService;
  final ApiService apiService;
  final AnalyticsService analyticsService;

  UserModule({
    required this.authService,
    required this.apiService,
    required this.analyticsService,
  });

  Future<void> viewProfile() async {
    analyticsService.logEvent('profile_viewed');

    final profileService = ProfileService(
      authService: authService,
      apiService: apiService,
      analyticsService: analyticsService,
    );

    await profileService.loadProfile();
  }
}
