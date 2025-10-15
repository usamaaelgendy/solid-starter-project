class Product {
  String id;
  String name;
  double price;

  Product({required this.id, required this.name, required this.price});
}

class ProductService {
  List<Product> products = [];

  void addProduct(Product product) {
    products.add(product);
  }

  void removeProduct(String id) {
    products.removeWhere((p) => p.id == id);
  }

  double calculateDiscount(Product product, String customerType) {
    if (customerType == 'premium') return product.price * 0.1;
    return 0.0;
  }

  Map<String, dynamic> toJson(Product product) {
    return {'id': product.id, 'name': product.name, 'price': product.price};
  }

  void exportToFile(String filename) {
    // File writing code
  }

  Future<void> syncWithServer() async {
    // HTTP requests
  }

  String formatForDisplay(Product product) {
    return '${product.name} - \$${product.price.toStringAsFixed(2)}';
  }
}

void main() async {
  final service = ProductService();
  final product = Product(id: 'PROD-001', name: 'Laptop', price: 999.99);

  service.addProduct(product);
  final discount = service.calculateDiscount(product, 'premium');
  final json = service.toJson(product);
  final display = service.formatForDisplay(product);

  print('Product added: ${product.name}');
  print('Discount: \$${discount.toStringAsFixed(2)}');
  print('JSON: $json');
  print('Display: $display');

  service.exportToFile('products.csv');
  await service.syncWithServer();
}
