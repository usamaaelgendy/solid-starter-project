mixin GiftWrappable {
  bool _isGiftWrapped = false;
  String _giftMessage = '';
  double _giftWrapCost = 4.99;

  void addGiftWrap(String message) {
    _isGiftWrapped = true;
    _giftMessage = message;
    print('Gift wrap added with message: "$message"');
  }

  void removeGiftWrap() {
    _isGiftWrapped = false;
    _giftMessage = '';
  }

  bool isGiftWrapped() => _isGiftWrapped;

  String getGiftMessage() => _giftMessage;

  double getGiftWrapCost() => _isGiftWrapped ? _giftWrapCost : 0.0;
}