import '../../domain/models/order.dart';
import '../database.dart';

class OrderRepository {
  final DatabaseHelper _db = DatabaseHelper();

  Future<List<Order>> getAll() async {
    final maps = await _db.getAllOrders();
    return maps.map((map) => Order.fromMap(map)).toList();
  }

  Future<Order?> getById(int id) async {
    final map = await _db.getOrderById(id);
    if (map == null || map.isEmpty) return null;
    return Order.fromMap(map);
  }

  Future<int> create(Order order) async {
    return await _db.insertOrder(order.toMap());
  }

  Future<int> update(Order order) async {
    return await _db.updateOrder(order.toMap());
  }

  Future<int> delete(int id) async {
    return await _db.deleteOrder(id);
  }

  Future<List<Map<String, dynamic>>> getAllWithDetails() async {
    final orders = await getAll();
    final customers = await _db.getAllCustomers();
    final products = await _db.getAllProducts();
    
    return orders.map((o) {
      final customer = customers.firstWhere(
        (c) => c['id'] == o.customerId,
        orElse: () => {},
      );
      final product = products.firstWhere(
        (p) => p['id'] == o.productId,
        orElse: () => {},
      );
      return {
        'id': o.id,
        'customerId': o.customerId,
        'productId': o.productId,
        'quantity': o.quantity,
        'orderDate': o.orderDate,
        'customerName': customer['name'] ?? 'Неизвестный',
        'productName': product['name'] ?? 'Неизвестный',
      };
    }).toList();
  }
}