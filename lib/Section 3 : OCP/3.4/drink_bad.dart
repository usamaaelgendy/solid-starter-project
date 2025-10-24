abstract class Drink {
  String getDescription();

  double getCost();
}

class Coffee implements Drink {
  @override
  String getDescription() => 'Coffee';

  @override
  double getCost() => 2.0;
}

class Tea implements Drink {
  @override
  String getDescription() => 'Tea';

  @override
  double getCost() => 1.5;
}

class CoffeeWithMilk implements Drink {
  @override
  String getDescription() => 'Coffee with Milk';

  @override
  double getCost() => 2.0 + 0.5;
}

class CoffeeWithSugar implements Drink {
  @override
  String getDescription() => 'Coffee with Sugar';

  @override
  double getCost() => 2.0 + 0.3;
}

class CoffeeWithMilkAndSugar implements Drink {
  @override
  String getDescription() => 'Coffee with Milk and Sugar';

  @override
  double getCost() => 2.0 + 0.5 + 0.3;
}

void main() {
  final order1 = CoffeeWithMilkAndSugar();
  print('${order1.getDescription()}: \$${order1.getCost()}');
}
