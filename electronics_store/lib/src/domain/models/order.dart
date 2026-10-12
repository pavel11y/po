import '../validators/number_validator.dart';
import '../validators/text_validator.dart';

class Order {
  int? id;
  int customerId;
  int productId;
  int quantity;
  String orderDate;

  Order({
    this.id,
    required this.customerId,
    required this.productId,
    required this.quantity,
    required this.orderDate,
  });

  List<String> validate() {
    final errors = <String>[];
    final customerError = validatePositive(customerId, 'ID клиента');
    if (customerError != null) errors.add(customerError);
    final productError = validatePositive(productId, 'ID товара');
    if (productError != null) errors.add(productError);
    final quantityError = validatePositive(quantity, 'Количество');
    if (quantityError != null) errors.add(quantityError);
    final dateError = validateRequired(orderDate, 'Дата заказа');
    if (dateError != null) errors.add(dateError);
    return errors;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'productId': productId,
      'quantity': quantity,
      'orderDate': orderDate,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      customerId: map['customerId'],
      productId: map['productId'],
      quantity: map['quantity'],
      orderDate: map['orderDate'],
    );
  }

  @override
  String toString() {
    return 'Заказ #$id | Клиент ID: $customerId | Товар ID: $productId | Кол-во: $quantity | Дата: $orderDate';
  }
}