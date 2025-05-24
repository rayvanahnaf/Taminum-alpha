class Product {
  final String name;
  final double price;

  const Product({required this.name, required this.price});

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Product && other.name == name);

  @override
  int get hashCode => name.hashCode;
}
