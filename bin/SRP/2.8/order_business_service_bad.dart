import 'dart:math';

// ❌ Multiple business responsibilities mixed together
class OrderBusinessService {
  // Price calculation logic
  double calculateOrderTotal(Order order) {
    double subtotal = 0;

    for (final item in order.items) {
      double itemPrice = item.quantity * item.unitPrice;

      // Bulk discount logic
      if (item.quantity >= 10) {
        itemPrice *= 0.9; // 10% discount
      } else if (item.quantity >= 5) {
        itemPrice *= 0.95; // 5% discount
      }

      // Category-based discount
      if (item.category == 'electronics') {
        itemPrice *= 0.92; // 8% electronics discount
      } else if (item.category == 'books') {
        itemPrice *= 0.88; // 12% books discount
      }

      subtotal += itemPrice;
    }

    // Loyalty program logic
    if (order.customer.loyaltyLevel == 'gold') {
      subtotal *= 0.9;
    } else if (order.customer.loyaltyLevel == 'silver') {
      subtotal *= 0.95;
    }

    // Tax calculation
    double tax = subtotal * _getTaxRate(order.customer.state);

    // Shipping calculation
    double shipping = _calculateShipping(order);

    return subtotal + tax + shipping;
  }

  // Inventory management logic
  bool validateInventoryAvailability(Order order) {
    for (final item in order.items) {
      final available = _getInventoryCount(item.productId);
      if (available < item.quantity) {
        return false;
      }
    }
    return true;
  }

  void reserveInventory(Order order) {
    for (final item in order.items) {
      _updateInventoryCount(item.productId, -item.quantity);
    }
  }

  void releaseInventory(Order order) {
    for (final item in order.items) {
      _updateInventoryCount(item.productId, item.quantity);
    }
  }

  // Order status logic
  bool canCancelOrder(Order order) {
    final hoursSinceCreation = DateTime.now()
        .difference(order.createdAt)
        .inHours;

    if (order.status == 'shipped') return false;
    if (order.status == 'delivered') return false;
    if (hoursSinceCreation > 24) return false;
    if (order.total > 500 && hoursSinceCreation > 12) return false;

    return true;
  }

  String getNextStatus(Order order) {
    switch (order.status) {
      case 'pending':
        return validateInventoryAvailability(order) ? 'confirmed' : 'on-hold';
      case 'confirmed':
        return 'processing';
      case 'processing':
        return 'shipped';
      case 'shipped':
        return 'delivered';
      default:
        return order.status;
    }
  }

  // Notification logic
  List<String> getNotificationRecipients(Order order, String event) {
    final recipients = <String>[order.customer.email];

    if (order.total > 1000) {
      recipients.add('manager@company.com');
    }

    if (event == 'cancelled' || event == 'refunded') {
      recipients.add('finance@company.com');
    }

    if (order.customer.isVip) {
      recipients.add('vip-support@company.com');
    }

    return recipients;
  }

  // Helper methods
  double _getTaxRate(String state) {
    switch (state) {
      case 'CA':
        return 0.0875;
      case 'NY':
        return 0.08;
      case 'TX':
        return 0.0625;
      default:
        return 0.05;
    }
  }

  double _calculateShipping(Order order) {
    double weight = order.items
        .map((item) => item.weight * item.quantity)
        .reduce((a, b) => a + b);

    if (order.customer.isPrime) return 0;
    if (order.total > 100) return 0;

    return weight * 0.5 + 5.0; // Base shipping formula
  }

  int _getInventoryCount(String productId) {
    // Simulate inventory lookup
    return Random().nextInt(100);
  }

  void _updateInventoryCount(String productId, int change) {
    // Simulate inventory update
    print('Updated inventory for $productId: $change');
  }
}

// Supporting classes
class Order {
  final String id;
  final Customer customer;
  final List<OrderItem> items;
  final String status;
  final DateTime createdAt;
  final double total;

  Order({
    required this.id,
    required this.customer,
    required this.items,
    required this.status,
    required this.createdAt,
    required this.total,
  });
}

class OrderItem {
  final String productId;
  final String category;
  final int quantity;
  final double unitPrice;
  final double weight;

  OrderItem({
    required this.productId,
    required this.category,
    required this.quantity,
    required this.unitPrice,
    required this.weight,
  });
}

class Customer {
  final String id;
  final String email;
  final String state;
  final String loyaltyLevel;
  final bool isVip;
  final bool isPrime;

  Customer({
    required this.id,
    required this.email,
    required this.state,
    required this.loyaltyLevel,
    required this.isVip,
    required this.isPrime,
  });
}

// Usage example
void badBusinessLogicExample() {
  final service = OrderBusinessService();

  final customer = Customer(
    id: '1',
    email: 'john@example.com',
    state: 'CA',
    loyaltyLevel: 'gold',
    isVip: true,
    isPrime: false,
  );

  final order = Order(
    id: 'ORD-001',
    customer: customer,
    items: [
      OrderItem(
        productId: 'LAPTOP-001',
        category: 'electronics',
        quantity: 2,
        unitPrice: 999.99,
        weight: 5.0,
      ),
    ],
    status: 'pending',
    createdAt: DateTime.now(),
    total: 0,
  );

  final total = service.calculateOrderTotal(order);
  final canCancel = service.canCancelOrder(order);
  print('Order total: \$${total.toStringAsFixed(2)}');
  print('Can cancel: $canCancel');
}
