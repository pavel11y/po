import '../../domain/models/category.dart';
import '../database.dart';

class CategoryRepository {
  final DatabaseHelper _db = DatabaseHelper();

  Future<List<Category>> getAll() async {
    final maps = await _db.getAllCategories();
    return maps.map((map) => Category.fromMap(map)).toList();
  }

  Future<Category?> getById(int id) async {
    final map = await _db.getCategoryById(id);
    if (map == null || map.isEmpty) return null;
    return Category.fromMap(map);
  }

  Future<int> create(Category category) async {
    return await _db.insertCategory(category.toMap());
  }

  Future<int> update(Category category) async {
    return await _db.updateCategory(category.toMap());
  }

  Future<int> delete(int id) async {
    return await _db.deleteCategory(id);
  }
}