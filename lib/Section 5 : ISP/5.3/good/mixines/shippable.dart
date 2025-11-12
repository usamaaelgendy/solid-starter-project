mixin Shippable {
  String _shippingAddress = '';
  String _trackingNumber = '';
  double _weight = 1.0;

  void setShippingAddress(String address) {
    _shippingAddress = address;
    print('Shipping address set to: $address');
  }

  String getShippingAddress() => _shippingAddress;

  void setWeight(double weight) {
    _weight = weight;
  }

  double calculateShippingCost() {
    if (_weight <= 1.0) return 5.99;
    if (_weight <= 5.0) return 9.99;
    return 14.99;
  }

  void setTrackingNumber(String tracking) {
    _trackingNumber = tracking;
    print('Tracking number: $tracking');
  }

  String getTrackingNumber() => _trackingNumber;

  Map<String, dynamic> getShippingInfo() {
    return {
      'address': _shippingAddress,
      'tracking': _trackingNumber,
      'cost': calculateShippingCost(),
      'weight': _weight,
    };
  }
}
