class Order {
  String id;
  double total;
  double subtotal;
  List<String> items;

  Order({
    required this.id,
    required this.total,
    required this.subtotal,
    required this.items,
  });
}

class OrderManager {
  bool isValidOrder(Order order) {
    return order.total > 0 && order.items.isNotEmpty;
  }

  double calculateTax(double subtotal) {
    return subtotal * 0.08;
  }

  void saveOrder(Order order) {
    print('Saving order ${order.id} to database');
  }

  void sendConfirmationEmail(Order order) {
    print('Sending confirmation for order ${order.id}');
  }

  void generateInvoice(Order order) {
    print('Generating PDF invoice for order ${order.id}');
  }
}

void main() {
  final order = Order(
    id: 'ORD-001',
    total: 100.0,
    subtotal: 92.59,
    items: ['Product A', 'Product B'],
  );

  final manager = OrderManager();
  if (manager.isValidOrder(order)) {
    final tax = manager.calculateTax(order.subtotal);
    order.total = order.subtotal + tax;
    manager.saveOrder(order);
    manager.sendConfirmationEmail(order);
    manager.generateInvoice(order);
  }
}
