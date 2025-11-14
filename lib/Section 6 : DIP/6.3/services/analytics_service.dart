
abstract class AnalyticsService {
  void logEvent(String event);
}

class AnalyticsServiceImpl implements AnalyticsService {
  @override
  void logEvent(String event) {
    print('Analytics: $event');
  }
}
