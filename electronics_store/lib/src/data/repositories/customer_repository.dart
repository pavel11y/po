import '../../domain/models/customer.dart';
import '../database.dart';

class CustomerRepository {
  final DatabaseHelper _db = DatabaseHelper();

  Future<List<Customer>> getAll() async {
    final maps = await _db.getAllCustomers();
    return maps.map((map) => Customer.fromMap(map)).toList();
  }

  Future<Customer?> getById(int id) async {
    final map = await _db.getCustomerById(id);
    if (map == null || map.isEmpty) return null;
    return Customer.fromMap(map);
  }

  Future<int> create(Customer customer) async {
    return await _db.insertCustomer(customer.toMap());
  }

  Future<int> update(Customer customer) async {
    return await _db.updateCustomer(customer.toMap());
  }

  Future<int> delete(int id) async {
    return await _db.deleteCustomer(id);
  }
}