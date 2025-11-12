import 'package:solid_examples/Section%205%20:%20ISP/5.3/good/mixines/renewable.dart';

class SubscriptionService with Renewable {
  String name;
  String description;

  SubscriptionService(this.name, this.description, double price, String cycle) {
    setRenewalInfo(price, cycle);
  }

  @override
  String toString() => 'Subscription: $name - \$${getRenewalPrice()}';
}
