import 'dart:io';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static const String _dbPath = 'electronics_store.json';
  late Map<String, dynamic> _data;

  Future<void> init() async {
    final file = File(_dbPath);
    if (await file.exists()) {
      final content = await file.readAsString();
      _data = jsonDecode(content);
    } else {
      _data = {
        'categories': [],
        'products': [],
        'suppliers': [],
        'customers': [],
        'orders': [],
        'nextIds': {
          'categories': 1,
          'products': 1,
          'suppliers': 1,
          'customers': 1,
          'orders': 1,
        }
      };
      await _save();
    }
  }

  Future<void> _save() async {
    final file = File(_dbPath);
    await file.writeAsString(jsonEncode(_data));
  }

  Future<List<Map<String, dynamic>>> getAllCategories() async {
    return List<Map<String, dynamic>>.from(_data['categories']);
  }

  Future<Map<String, dynamic>?> getCategoryById(int id) async {
    final categories = await getAllCategories();
    return categories.cast<Map<String, dynamic>>().firstWhere(
      (c) => c['id'] == id,
      orElse: () => {},
    );
  }

  Future<int> insertCategory(Map<String, dynamic> category) async {
    final id = _data['nextIds']['categories'];
    category['id'] = id;
    _data['categories'].add(category);
    _data['nextIds']['categories'] = id + 1;
    await _save();
    return id;
  }

  Future<int> updateCategory(Map<String, dynamic> category) async {
    final index = _data['categories'].indexWhere((c) => c['id'] == category['id']);
    if (index != -1) {
      _data['categories'][index] = category;
      await _save();
      return 1;
    }
    return 0;
  }

  Future<int> deleteCategory(int id) async {
    _data['categories'].removeWhere((c) => c['id'] == id);
    await _save();
    return 1;
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    return List<Map<String, dynamic>>.from(_data['products']);
  }

  Future<Map<String, dynamic>?> getProductById(int id) async {
    final products = await getAllProducts();
    return products.cast<Map<String, dynamic>>().firstWhere(
      (p) => p['id'] == id,
      orElse: () => {},
    );
  }

  Future<int> insertProduct(Map<String, dynamic> product) async {
    final id = _data['nextIds']['products'];
    product['id'] = id;
    _data['products'].add(product);
    _data['nextIds']['products'] = id + 1;
    await _save();
    return id;
  }

  Future<int> updateProduct(Map<String, dynamic> product) async {
    final index = _data['products'].indexWhere((p) => p['id'] == product['id']);
    if (index != -1) {
      _data['products'][index] = product;
      await _save();
      return 1;
    }
    return 0;
  }

  Future<int> deleteProduct(int id) async {
    _data['products'].removeWhere((p) => p['id'] == id);
    await _save();
    return 1;
  }

  Future<List<Map<String, dynamic>>> getAllSuppliers() async {
    return List<Map<String, dynamic>>.from(_data['suppliers']);
  }

  Future<Map<String, dynamic>?> getSupplierById(int id) async {
    final suppliers = await getAllSuppliers();
    return suppliers.cast<Map<String, dynamic>>().firstWhere(
      (s) => s['id'] == id,
      orElse: () => {},
    );
  }

  Future<int> insertSupplier(Map<String, dynamic> supplier) async {
    final id = _data['nextIds']['suppliers'];
    supplier['id'] = id;
    _data['suppliers'].add(supplier);
    _data['nextIds']['suppliers'] = id + 1;
    await _save();
    return id;
  }

  Future<int> updateSupplier(Map<String, dynamic> supplier) async {
    final index = _data['suppliers'].indexWhere((s) => s['id'] == supplier['id']);
    if (index != -1) {
      _data['suppliers'][index] = supplier;
      await _save();
      return 1;
    }
    return 0;
  }

  Future<int> deleteSupplier(int id) async {
    _data['suppliers'].removeWhere((s) => s['id'] == id);
    await _save();
    return 1;
  }

  Future<List<Map<String, dynamic>>> getAllCustomers() async {
    return List<Map<String, dynamic>>.from(_data['customers']);
  }

  Future<Map<String, dynamic>?> getCustomerById(int id) async {
    final customers = await getAllCustomers();
    return customers.cast<Map<String, dynamic>>().firstWhere(
      (c) => c['id'] == id,
      orElse: () => {},
    );
  }

  Future<int> insertCustomer(Map<String, dynamic> customer) async {
    final id = _data['nextIds']['customers'];
    customer['id'] = id;
    _data['customers'].add(customer);
    _data['nextIds']['customers'] = id + 1;
    await _save();
    return id;
  }

  Future<int> updateCustomer(Map<String, dynamic> customer) async {
    final index = _data['customers'].indexWhere((c) => c['id'] == customer['id']);
    if (index != -1) {
      _data['customers'][index] = customer;
      await _save();
      return 1;
    }
    return 0;
  }

  Future<int> deleteCustomer(int id) async {
    _data['customers'].removeWhere((c) => c['id'] == id);
    await _save();
    return 1;
  }

  Future<List<Map<String, dynamic>>> getAllOrders() async {
    return List<Map<String, dynamic>>.from(_data['orders']);
  }

  Future<Map<String, dynamic>?> getOrderById(int id) async {
    final orders = await getAllOrders();
    return orders.cast<Map<String, dynamic>>().firstWhere(
      (o) => o['id'] == id,
      orElse: () => {},
    );
  }

  Future<int> insertOrder(Map<String, dynamic> order) async {
    final id = _data['nextIds']['orders'];
    order['id'] = id;
    _data['orders'].add(order);
    _data['nextIds']['orders'] = id + 1;
    await _save();
    return id;
  }

  Future<int> updateOrder(Map<String, dynamic> order) async {
    final index = _data['orders'].indexWhere((o) => o['id'] == order['id']);
    if (index != -1) {
      _data['orders'][index] = order;
      await _save();
      return 1;
    }
    return 0;
  }

  Future<int> deleteOrder(int id) async {
    _data['orders'].removeWhere((o) => o['id'] == id);
    await _save();
    return 1;
  }

  Future<void> close() async {
    await _save();
  }
}

Future<void> initDatabase() async {
  final db = DatabaseHelper();
  await db.init();
}