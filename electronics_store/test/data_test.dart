import 'package:test/test.dart';
import 'package:electronics_store/my_app.dart';
import 'dart:io';

void main() {
  setUpAll(() async {
    await initDatabase();
  });

  tearDownAll(() async {
    final file = File('electronics_store.json');
    if (await file.exists()) {
      await file.delete();
    }
  });

  test('Вставка и чтение категории из БД', () async {
    final db = DatabaseHelper();
    
    final id = await db.insertCategory({
      'name': 'Тестовая категория',
      'description': 'Описание теста',
    });
    
    final categories = await db.getAllCategories();
    final category = categories.firstWhere((c) => c['id'] == id);
    
    expect(category['name'], 'Тестовая категория');
    expect(category['description'], 'Описание теста');
  });

  test('Вставка и чтение товара с внешним ключом', () async {
    final db = DatabaseHelper();
    
    final categoryId = await db.insertCategory({
      'name': 'Смартфоны',
      'description': 'Мобильные устройства',
    });
    
    final productId = await db.insertProduct({
      'name': 'Телефон X',
      'price': 599.99,
      'stock': 15,
      'categoryId': categoryId,
      'supplierId': null,
    });
    
    final products = await db.getAllProducts();
    final product = products.firstWhere((p) => p['id'] == productId);
    
    expect(product['name'], 'Телефон X');
    expect(product['categoryId'], categoryId);
  });

  test('Обновление категории', () async {
    final db = DatabaseHelper();
    
    final id = await db.insertCategory({
      'name': 'Старое имя',
      'description': 'Старое описание',
    });
    
    await db.updateCategory({
      'id': id,
      'name': 'Новое имя',
      'description': 'Новое описание',
    });
    
    final updated = await db.getCategoryById(id);
    expect(updated!['name'], 'Новое имя');
    expect(updated['description'], 'Новое описание');
  });

  test('Удаление категории', () async {
    final db = DatabaseHelper();
    
    final id = await db.insertCategory({
      'name': 'Для удаления',
      'description': 'Будет удалено',
    });
    
    await db.deleteCategory(id);
    
    final deleted = await db.getCategoryById(id);
    expect(deleted, null);
  });

  test('Связь Product -> Category (внешний ключ)', () async {
    final db = DatabaseHelper();
    
    final categoryId = await db.insertCategory({
      'name': 'Ноутбуки',
      'description': 'Портативные компьютеры',
    });
    
    final productId = await db.insertProduct({
      'name': 'MacBook Pro',
      'price': 1999.99,
      'stock': 5,
      'categoryId': categoryId,
      'supplierId': null,
    });
    
    final product = await db.getProductById(productId);
    final category = await db.getCategoryById(product!['categoryId']);
    
    expect(category!['name'], 'Ноутбуки');
    expect(product['name'], 'MacBook Pro');
  });
}