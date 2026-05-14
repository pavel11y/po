import '../../domain/models/product.dart';
import '../database.dart';

class ProductRepository {
  final DatabaseHelper _db = DatabaseHelper();

  Future<List<Product>> getAll() async {
    final maps = await _db.getAllProducts();
    return maps.map((map) => Product.fromMap(map)).toList();
  }

  Future<Product?> getById(int id) async {
    final map = await _db.getProductById(id);
    if (map == null || map.isEmpty) return null;
    return Product.fromMap(map);
  }

  Future<int> create(Product product) async {
    return await _db.insertProduct(product.toMap());
  }

  Future<int> update(Product product) async {
    return await _db.updateProduct(product.toMap());
  }

  Future<int> delete(int id) async {
    return await _db.deleteProduct(id);
  }

  Future<List<Map<String, dynamic>>> getAllWithRelations() async {
    final products = await getAll();
    final categories = await _db.getAllCategories();
    final suppliers = await _db.getAllSuppliers();
    
    return products.map((p) {
      final category = categories.firstWhere(
        (c) => c['id'] == p.categoryId,
        orElse: () => {},
      );
      final supplier = suppliers.firstWhere(
        (s) => s['id'] == p.supplierId,
        orElse: () => {},
      );
      return {
        'id': p.id,
        'name': p.name,
        'price': p.price,
        'stock': p.stock,
        'categoryId': p.categoryId,
        'supplierId': p.supplierId,
        'categoryName': category['name'] ?? 'Нет',
        'supplierName': supplier['name'] ?? 'Нет',
      };
    }).toList();
  }
}