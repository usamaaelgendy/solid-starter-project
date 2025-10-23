class Order {
  String id;
  double total;
  List<String> items;

  Order({required this.id, required this.total, required this.items});
}

class OrderManager {
  // Job 1: Validation
  bool isValidOrder(Order order) {
    return order.total > 0 && order.items.isNotEmpty;
  }

  // Job 2: Calculations
  double calculateTax(double subtotal) {
    return subtotal * 0.08;
  }

  // Job 3: Database operations
  void saveOrder(Order order) {
    print('Saving to database...');
  }

  // Job 4: Email notifications
  void sendConfirmationEmail(Order order) {
    print('Sending email...');
  }

  // Job 5: Report generation
  void generateInvoice(Order order) {
    print('Generating PDF...');
  }
}

void main() {
  final manager = OrderManager();
  final order = Order(id: 'ORD-001', total: 100.0, items: ['Item1']);

  // One class doing everything - messy!
  if (manager.isValidOrder(order)) {
    final tax = manager.calculateTax(92.59);
    manager.saveOrder(order);
    manager.sendConfirmationEmail(order);
    manager.generateInvoice(order);
  }
}
