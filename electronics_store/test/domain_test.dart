import 'package:test/test.dart';
import 'package:electronics_store/my_app.dart';

void main() {
  group('Тесты сущности Category', () {
    test('toMap and fromMap', () {
      final category = Category(
        id: 1, 
        name: 'Смартфоны', 
        description: 'Мобильные телефоны и аксессуары'
      );
      final map = category.toMap();
      final restored = Category.fromMap(map);
      
      expect(restored.id, category.id);
      expect(restored.name, category.name);
      expect(restored.description, category.description);
    });
    
    test('Валидация Category', () {
      final validCategory = Category(name: 'Телефоны', description: 'Описание');
      expect(validCategory.validate(), isEmpty);
      
      final invalidCategory = Category(name: '', description: '');
      expect(invalidCategory.validate(), isNotEmpty);
    });
  });

  group('Тесты сущности Product', () {
    test('toMap and fromMap', () {
      final product = Product(
        id: 1,
        name: 'iPhone 15',
        price: 799.99,
        stock: 10,
        categoryId: 1,
        supplierId: 1,
      );
      final map = product.toMap();
      final restored = Product.fromMap(map);
      
      expect(restored.id, product.id);
      expect(restored.name, product.name);
      expect(restored.price, product.price);
      expect(restored.stock, product.stock);
      expect(restored.categoryId, product.categoryId);
      expect(restored.supplierId, product.supplierId);
    });
    
    test('Валидация Product', () {
      final validProduct = Product(
        name: 'iPhone', 
        price: 1000, 
        stock: 5, 
        categoryId: 1
      );
      expect(validProduct.validate(), isEmpty);
      
      final invalidProduct = Product(
        name: '', 
        price: 0, 
        stock: 0, 
        categoryId: 0
      );
      expect(invalidProduct.validate(), isNotEmpty);
    });
  });

  group('Тесты сущности Supplier', () {
    test('toMap and fromMap', () {
      final supplier = Supplier(
        id: 1,
        name: 'ООО Электро',
        phone: '+79991234567',
        email: 'info@elektro.ru',
      );
      final map = supplier.toMap();
      final restored = Supplier.fromMap(map);
      
      expect(restored.id, supplier.id);
      expect(restored.name, supplier.name);
      expect(restored.phone, supplier.phone);
      expect(restored.email, supplier.email);
    });
  });

  group('Тесты сущности Customer', () {
    test('toMap and fromMap', () {
      final customer = Customer(
        id: 1,
        name: 'Иван Петров',
        email: 'ivan@mail.ru',
      );
      final map = customer.toMap();
      final restored = Customer.fromMap(map);
      
      expect(restored.id, customer.id);
      expect(restored.name, customer.name);
      expect(restored.email, customer.email);
    });
  });

  group('Тесты сущности Order', () {
    test('toMap and fromMap', () {
      final order = Order(
        id: 1,
        customerId: 1,
        productId: 1,
        quantity: 2,
        orderDate: '2026-05-14T10:00:00',
      );
      final map = order.toMap();
      final restored = Order.fromMap(map);
      
      expect(restored.id, order.id);
      expect(restored.customerId, order.customerId);
      expect(restored.productId, order.productId);
      expect(restored.quantity, order.quantity);
      expect(restored.orderDate, order.orderDate);
    });
  });
}