import 'package:solid_examples/Section%206%20:%20DIP/6.3/services/analytics_service.dart';
import 'package:solid_examples/Section%206%20:%20DIP/6.3/services/api_service.dart';
import 'package:solid_examples/Section%206%20:%20DIP/6.3/services/auth_service.dart';
import 'package:solid_examples/Section%206%20:%20DIP/6.3/user_module.dart';

class Application {
  final AuthService authService;
  final ApiService apiService;
  final AnalyticsService analyticsService;

  Application({
    required this.authService,
    required this.apiService,
    required this.analyticsService,
  });

  Future<void> run() async {
    print('Starting application...');
    analyticsService.logEvent('app_started');

    final userModule = UserModule(
      authService: authService,
      apiService: apiService,
      analyticsService: analyticsService,
    );

    await userModule.viewProfile();
  }
}
