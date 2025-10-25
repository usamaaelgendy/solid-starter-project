abstract class PaymentMethod {
  String accountNumber;
  String holderName;

  PaymentMethod({required this.accountNumber, required this.holderName});

  bool processRefund(double amount) {
    print('Processing refund of \$$amount to $holderName');
    print('Refund successful to account: $accountNumber');
    return true;
  }

  bool processPayment(double amount) {
    print('Processing payment of \$$amount from $holderName');
    return true;
  }
}

class CreditCard extends PaymentMethod {
  String cvv;
  String expiryDate;

  CreditCard({
    required super.accountNumber,
    required super.holderName,
    required this.cvv,
    required this.expiryDate,
  });

  @override
  bool processPayment(double amount) {
    print(
      'Charging \$$amount to credit card ending in ${accountNumber.substring(accountNumber.length - 4)}',
    );
    return true;
  }

  @override
  bool processRefund(double amount) {
    print(
      'Refunding \$$amount to credit card ending in ${accountNumber.substring(accountNumber.length - 4)}',
    );
    return true;
  }
}

class BankAccount extends PaymentMethod {
  String bankName;
  String routingNumber;

  BankAccount({
    required super.accountNumber,
    required super.holderName,
    required this.bankName,
    required this.routingNumber,
  });

  @override
  bool processPayment(double amount) {
    print('Withdrawing \$$amount from $bankName account: $accountNumber');
    return true;
  }

  @override
  bool processRefund(double amount) {
    print(
      'Depositing refund of \$$amount to $bankName account: $accountNumber',
    );
    return true;
  }
}

class GiftCard extends PaymentMethod {
  double balance;

  GiftCard({required String cardNumber, required this.balance})
    : super(accountNumber: cardNumber, holderName: 'Gift Card');

  @override
  bool processPayment(double amount) {
    if (amount > balance) {
      print('Insufficient balance on gift card');
      return false;
    }
    balance -= amount;
    print('Paid \$$amount using gift card. Remaining balance: \$$balance');
    return true;
  }

  @override
  bool processRefund(double amount) {
    throw Exception(
      'Gift cards cannot receive refunds! They can only be reloaded.',
    );
  }

  void reload(double amount) {
    balance += amount;
    print('Gift card reloaded with \$$amount. New balance: \$$balance');
  }
}

void processReturn(PaymentMethod paymentMethod, double amount) {
  print('\n--- Processing return of \$$amount ---');
  paymentMethod.processRefund(amount);
}

void main() {
  final creditCard = CreditCard(
    accountNumber: '4532123456789012',
    holderName: 'John Doe',
    cvv: '123',
    expiryDate: '12/25',
  );

  final bankAccount = BankAccount(
    accountNumber: '123456789',
    holderName: 'Jane Smith',
    bankName: 'ABC Bank',
    routingNumber: '987654321',
  );

  final giftCard = GiftCard(cardNumber: 'GIFT-5000', balance: 50.0);




  processReturn(creditCard, 29.99);

  processReturn(bankAccount, 49.99);

  try {
    processReturn(giftCard, 19.99);
  } catch (e) {
    print('💥 Error: $e');
  }

  void safeProcessReturn(PaymentMethod payment, double amount) {
    if (payment is GiftCard) {
      print('Cannot refund to gift card - reloading instead');
      payment.reload(amount);
    } else {
      payment.processRefund(amount);
    }
  }

  print('\n--- Using special checks (bad practice) ---');
  safeProcessReturn(giftCard, 19.99);
}
