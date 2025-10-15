import 'dart:convert';
import 'dart:io';
import 'dart:math';

// ❌ This class violates SRP with 14 different responsibilities mixed together
// YOUR TASK: Identify all responsibilities and separate them into focused classes
class OrderProcessor {
  final Map<String, dynamic> _inventory = {};
  final List<Map<String, dynamic>> _orders = [];
  final List<Map<String, dynamic>> _customers = [];

  // Mixed responsibility: Order creation + Validation + Inventory + Pricing + Email + Logging
  Future<String> processOrder({
    required String customerId,
    required List<Map<String, dynamic>> items,
    required String shippingAddress,
    String? promoCode,
  }) async {
    try {
      print('Processing order for customer: $customerId');

      // Customer validation (should be separate)
      final customer = _customers.firstWhere(
        (c) => c['id'] == customerId,
        orElse: () => {},
      );

      if (customer.isEmpty) {
        throw Exception('Customer not found');
      }

      if (customer['status'] != 'active') {
        throw Exception('Customer account is not active');
      }

      // Order validation (should be separate)
      if (items.isEmpty) {
        throw Exception('Order must contain at least one item');
      }

      if (shippingAddress.isEmpty) {
        throw Exception('Shipping address is required');
      }

      // Inventory checking (should be separate)
      for (final item in items) {
        final productId = item['productId'];
        final quantity = item['quantity'] as int;

        if (!_inventory.containsKey(productId)) {
          throw Exception('Product $productId not found in inventory');
        }

        final availableStock = _inventory[productId]['stock'] as int;
        if (availableStock < quantity) {
          throw Exception('Insufficient stock for product $productId');
        }
      }

      // Price calculation with discounts (should be separate)
      double totalAmount = 0;
      final processedItems = <Map<String, dynamic>>[];

      for (final item in items) {
        final productId = item['productId'];
        final quantity = item['quantity'] as int;
        final productInfo = _inventory[productId];
        final unitPrice = productInfo['price'] as double;

        double itemTotal = unitPrice * quantity;

        // Bulk discount logic (should be separate)
        if (quantity >= 10) {
          itemTotal *= 0.9; // 10% discount
        } else if (quantity >= 5) {
          itemTotal *= 0.95; // 5% discount
        }

        // Category discount (should be separate)
        final category = productInfo['category'] as String;
        if (category == 'electronics') {
          itemTotal *= 0.92; // 8% discount
        } else if (category == 'books') {
          itemTotal *= 0.88; // 12% discount
        }

        totalAmount += itemTotal;

        processedItems.add({
          'productId': productId,
          'productName': productInfo['name'],
          'quantity': quantity,
          'unitPrice': unitPrice,
          'itemTotal': itemTotal,
        });
      }

      // Promo code validation and discount (should be separate)
      double promoDiscount = 0;
      if (promoCode != null && promoCode.isNotEmpty) {
        if (promoCode == 'SAVE10') {
          promoDiscount = totalAmount * 0.1;
        } else if (promoCode == 'SAVE20' && totalAmount > 100) {
          promoDiscount = totalAmount * 0.2;
        } else if (promoCode == 'FIRSTORDER' && _isFirstOrder(customerId)) {
          promoDiscount = totalAmount * 0.15;
        } else {
          throw Exception('Invalid promo code');
        }
      }

      totalAmount -= promoDiscount;

      // Tax calculation (should be separate)
      final customerState = customer['state'] as String;
      double taxRate = 0.05; // Default 5%
      switch (customerState) {
        case 'CA':
          taxRate = 0.0875;
          break;
        case 'NY':
          taxRate = 0.08;
          break;
        case 'TX':
          taxRate = 0.0625;
          break;
      }

      final taxAmount = totalAmount * taxRate;
      final finalAmount = totalAmount + taxAmount;

      // Shipping calculation (should be separate)
      double shippingCost = 0;
      final isPremiumCustomer = customer['tier'] == 'premium';
      if (!isPremiumCustomer && finalAmount < 50) {
        shippingCost = 9.99;
      } else if (!isPremiumCustomer && finalAmount < 100) {
        shippingCost = 4.99;
      }
      // Premium customers and orders over $100 get free shipping

      final orderTotal = finalAmount + shippingCost;

      // Payment processing simulation (should be separate)
      final paymentResult = await _processPayment(
        customerId: customerId,
        amount: orderTotal,
        paymentMethod: customer['defaultPaymentMethod'],
      );

      if (!paymentResult['success']) {
        throw Exception('Payment failed: ${paymentResult['error']}');
      }

      // Inventory update (should be separate)
      for (final item in items) {
        final productId = item['productId'];
        final quantity = item['quantity'] as int;
        _inventory[productId]['stock'] =
            (_inventory[productId]['stock'] as int) - quantity;
      }

      // Order creation and storage (should be separate)
      final orderId = _generateOrderId();
      final order = {
        'id': orderId,
        'customerId': customerId,
        'items': processedItems,
        'subtotal': totalAmount + promoDiscount,
        'promoDiscount': promoDiscount,
        'taxAmount': taxAmount,
        'shippingCost': shippingCost,
        'total': orderTotal,
        'status': 'confirmed',
        'shippingAddress': shippingAddress,
        'createdAt': DateTime.now().toIso8601String(),
        'paymentTransactionId': paymentResult['transactionId'],
      };

      _orders.add(order);

      // Email notification (should be separate)
      await _sendOrderConfirmationEmail(customer, order);

      // SMS notification for premium customers (should be separate)
      if (isPremiumCustomer) {
        await _sendOrderSMS(customer['phone'], orderId);
      }

      // Logging and analytics (should be separate)
      await _logOrderEvent('ORDER_CREATED', {
        'orderId': orderId,
        'customerId': customerId,
        'amount': orderTotal,
        'itemCount': items.length,
        'promoCode': promoCode,
      });

      // Update customer statistics (should be separate)
      _updateCustomerStats(customerId, orderTotal);

      // Inventory reorder check (should be separate)
      await _checkLowStock();

      print('Order $orderId processed successfully');
      return orderId;
    } catch (e) {
      // Error logging (should be separate)
      await _logOrderEvent('ORDER_FAILED', {
        'customerId': customerId,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      rethrow;
    }
  }

  // All helper methods mixed in - should be distributed to appropriate classes
  bool _isFirstOrder(String customerId) {
    return !_orders.any((order) => order['customerId'] == customerId);
  }

  String _generateOrderId() {
    return 'ORD-${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<Map<String, dynamic>> _processPayment({
    required String customerId,
    required double amount,
    required String paymentMethod,
  }) async {
    await Future.delayed(Duration(milliseconds: 500));
    if (Random().nextBool()) {
      return {
        'success': true,
        'transactionId': 'TXN-${DateTime.now().millisecondsSinceEpoch}',
      };
    } else {
      return {'success': false, 'error': 'Card declined'};
    }
  }

  Future<void> _sendOrderConfirmationEmail(
    Map<String, dynamic> customer,
    Map<String, dynamic> order,
  ) async {
    print('Sending order confirmation email to ${customer['email']}');
    await Future.delayed(Duration(milliseconds: 200));
  }

  Future<void> _sendOrderSMS(String phone, String orderId) async {
    print('Sending SMS to $phone: Your order $orderId has been confirmed');
    await Future.delayed(Duration(milliseconds: 100));
  }

  Future<void> _logOrderEvent(String event, Map<String, dynamic> data) async {
    print(
      'LOG: ${jsonEncode({'event': event, 'data': data, 'timestamp': DateTime.now().toIso8601String()})}',
    );
    await Future.delayed(Duration(milliseconds: 50));
  }

  void _updateCustomerStats(String customerId, double orderAmount) {
    final customerIndex = _customers.indexWhere((c) => c['id'] == customerId);
    if (customerIndex != -1) {
      final customer = _customers[customerIndex];
      customer['totalSpent'] =
          (customer['totalSpent'] as double? ?? 0.0) + orderAmount;
      customer['orderCount'] = (customer['orderCount'] as int? ?? 0) + 1;
    }
  }

  Future<void> _checkLowStock() async {
    for (final entry in _inventory.entries) {
      final stock = entry.value['stock'] as int;
      final minStock = entry.value['minStock'] as int? ?? 10;
      if (stock <= minStock) {
        print(
          'LOW STOCK ALERT: Product ${entry.key} has only $stock units left',
        );
      }
    }
  }
}
