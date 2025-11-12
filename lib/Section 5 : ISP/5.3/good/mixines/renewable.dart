mixin Renewable {
  DateTime? _nextRenewalDate;
  double _renewalPrice = 0.0;
  bool _autoRenew = true;
  String _billingCycle = 'monthly';

  void setRenewalInfo(double price, String cycle) {
    _renewalPrice = price;
    _billingCycle = cycle;
    _calculateNextRenewal();
  }

  void _calculateNextRenewal() {
    if (_billingCycle == 'monthly') {
      _nextRenewalDate = DateTime.now().add(Duration(days: 30));
    } else if (_billingCycle == 'yearly') {
      _nextRenewalDate = DateTime.now().add(Duration(days: 365));
    }
  }

  void renew() {
    print('Subscription renewed for \$${_renewalPrice}');
    _calculateNextRenewal();
  }

  void cancel() {
    _autoRenew = false;
    print('Subscription cancelled. Valid until: $_nextRenewalDate');
  }

  void pause() {
    _autoRenew = false;
    print('Subscription paused');
  }

  bool isAutoRenewEnabled() => _autoRenew;

  DateTime? getNextRenewalDate() => _nextRenewalDate;

  double getRenewalPrice() => _renewalPrice;
}
