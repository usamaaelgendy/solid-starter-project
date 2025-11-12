mixin Returnable {
  int _returnWindowDays = 30;
  bool _isReturned = false;

  void setReturnWindow(int days) {
    _returnWindowDays = days;
  }

  bool canReturn() => !_isReturned;

  int getReturnWindowDays() => _returnWindowDays;

  void initiateReturn(String reason) {
    if (!canReturn()) {
      throw StateError('This item has already been returned');
    }
    _isReturned = true;
    print('Return initiated. Reason: $reason');
    print('Return window: $_returnWindowDays days');
  }

  bool isReturned() => _isReturned;
}
