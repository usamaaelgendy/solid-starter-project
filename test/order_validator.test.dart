import 'package:solid_examples/SRP/2.2/order_manager_bad.dart';

void testValidation() {
  OrderValidator orderValidator = OrderValidator();

  assert(!orderValidator.isValidOrder(Order(id: "1", total: 200, items: [])));
}
