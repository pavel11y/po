import '../validators/text_validator.dart';
import '../validators/number_validator.dart';

class Product {
  int? id;
  String name;
  double price;
  int stock;
  int categoryId;
  int? supplierId;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.categoryId,
    this.supplierId,
  });

  List<String> validate() {
    final errors = <String>[];
    final nameError = validateRequired(name, 'Название товара');
    if (nameError != null) errors.add(nameError);
    final priceError = validatePositive(price, 'Цена');
    if (priceError != null) errors.add(priceError);
    final stockError = validatePositive(stock, 'Количество');
    if (stockError != null) errors.add(stockError);
    final catError = validatePositive(categoryId, 'ID категории');
    if (catError != null) errors.add(catError);
    return errors;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'stock': stock,
      'categoryId': categoryId,
      'supplierId': supplierId,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      stock: map['stock'],
      categoryId: map['categoryId'],
      supplierId: map['supplierId'],
    );
  }

  @override
  String toString() {
    return 'ID: $id | $name | Цена: $price₽ | В наличии: $stock | Категория ID: $categoryId';
  }
}