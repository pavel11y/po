import '../../domain/models/supplier.dart';
import '../database.dart';

class SupplierRepository {
  final DatabaseHelper _db = DatabaseHelper();

  Future<List<Supplier>> getAll() async {
    final maps = await _db.getAllSuppliers();
    return maps.map((map) => Supplier.fromMap(map)).toList();
  }

  Future<Supplier?> getById(int id) async {
    final map = await _db.getSupplierById(id);
    if (map == null || map.isEmpty) return null;
    return Supplier.fromMap(map);
  }

  Future<int> create(Supplier supplier) async {
    return await _db.insertSupplier(supplier.toMap());
  }

  Future<int> update(Supplier supplier) async {
    return await _db.updateSupplier(supplier.toMap());
  }

  Future<int> delete(int id) async {
    return await _db.deleteSupplier(id);
  }
}