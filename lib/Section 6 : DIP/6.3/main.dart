import 'package:solid_examples/Section%206%20:%20DIP/6.3/app.dart';
import 'package:solid_examples/Section%206%20:%20DIP/6.3/services/analytics_service.dart';
import 'package:solid_examples/Section%206%20:%20DIP/6.3/services/api_service.dart';
import 'package:solid_examples/Section%206%20:%20DIP/6.3/services/auth_service.dart';

void main() async {
  final authService = AuthServiceImpl();
  final apiService = RestApiService(authService);
  final analyticsService = AnalyticsServiceImpl();

  final app = Application(
    authService: authService,
    apiService: apiService,
    analyticsService: analyticsService,
  );

  await app.run();
}
