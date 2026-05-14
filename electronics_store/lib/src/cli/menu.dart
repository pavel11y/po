import 'dart:io';
import 'input_helper.dart';
import '../data/repositories/category_repository.dart';
import '../data/repositories/product_repository.dart';
import '../data/repositories/supplier_repository.dart';
import '../data/repositories/customer_repository.dart';
import '../data/repositories/order_repository.dart';
import '../domain/models/category.dart';
import '../domain/models/product.dart';
import '../domain/models/supplier.dart';
import '../domain/models/customer.dart';
import '../domain/models/order.dart';

class Menu {
  final CategoryRepository _categoryRepo = CategoryRepository();
  final ProductRepository _productRepo = ProductRepository();
  final SupplierRepository _supplierRepo = SupplierRepository();
  final CustomerRepository _customerRepo = CustomerRepository();
  final OrderRepository _orderRepo = OrderRepository();

  Future<void> run() async {
    while (true) {
      print('1. Управление категориями');
      print('2. Управление товарами');
      print('3. Управление поставщиками');
      print('4. Управление клиентами');
      print('5. Управление заказами');
      print('6. ПОКАЗАТЬ ВСЁ ИЗ БД');
      print('0. Выход');

      final choice = InputHelper.askInt('Выберите пункт', positive: false);
      
      switch (choice) {
        case 1:
          await _categoryMenu();
          break;
        case 2:
          await _productMenu();
          break;
        case 3:
          await _supplierMenu();
          break;
        case 4:
          await _customerMenu();
          break;
        case 5:
          await _orderMenu();
          break;
        case 6:
          await _showAll();
          break;
        case 0:
          print('До свидания!');
          return;
        default:
          print('Неверный выбор');
      }
    }
  }

  Future<void> _categoryMenu() async {
    while (true) {
      print('Категории');
      print('1. Список категорий');
      print('2. Добавить категорию');
      print('3. Редактировать категорию');
      print('4. Удалить категорию');
      print('0. Назад');
      
      final choice = InputHelper.askInt('Выбор', positive: false);
      
      switch (choice) {
        case 1:
          final categories = await _categoryRepo.getAll();
          if (categories.isEmpty) {
            print('Категории не найдены');
          } else {
            for (var c in categories) print(c);
          }
          break;
        case 2:
          final name = InputHelper.askString('Название категории');
          final desc = InputHelper.askString('Описание');
          final category = Category(name: name, description: desc);
          final errors = category.validate();
          if (errors.isNotEmpty) {
            print('Ошибки: ${errors.join(', ')}');
          } else {
            final id = await _categoryRepo.create(category);
            print('Категория добавлена с ID: $id');
          }
          break;
        case 3:
          final id = InputHelper.askInt('ID категории для редактирования');
          final existing = await _categoryRepo.getById(id);
          if (existing == null) {
            print('Категория не найдена');
            break;
          }
          final name = InputHelper.askString('Новое название (${existing.name})');
          final desc = InputHelper.askString('Новое описание (${existing.description})');
          final updated = Category(id: id, name: name, description: desc);
          final errors = updated.validate();
          if (errors.isNotEmpty) {
            print('Ошибки: ${errors.join(', ')}');
          } else {
            await _categoryRepo.update(updated);
            print('Категория обновлена');
          }
          break;
        case 4:
          final id = InputHelper.askInt('ID категории для удаления');
          await _categoryRepo.delete(id);
          print('Категория удалена');
          break;
        case 0:
          return;
      }
    }
  }

  Future<void> _productMenu() async {
    while (true) {
      print('Товары');
      print('1. Список товаров');
      print('2. Добавить товар');
      print('3. Редактировать товар');
      print('4. Удалить товар');
      print('0. Назад');
      
      final choice = InputHelper.askInt('Выбор', positive: false);
      
      switch (choice) {
        case 1:
          final products = await _productRepo.getAll();
          if (products.isEmpty) {
            print('Товары не найдены');
          } else {
            for (var p in products) print(p);
          }
          break;
        case 2:
          final name = InputHelper.askString('Название товара');
          final price = InputHelper.askDouble('Цена');
          final stock = InputHelper.askInt('Количество');
          final categoryId = InputHelper.askInt('ID категории');
          final supplierId = InputHelper.askIntOptional('ID поставщика');
          final product = Product(
            name: name,
            price: price,
            stock: stock,
            categoryId: categoryId,
            supplierId: supplierId,
          );
          final errors = product.validate();
          if (errors.isNotEmpty) {
            print('Ошибки: ${errors.join(', ')}');
          } else {
            final id = await _productRepo.create(product);
            print('Товар добавлен с ID: $id');
          }
          break;
        case 3:
          final id = InputHelper.askInt('ID товара для редактирования');
          final existing = await _productRepo.getById(id);
          if (existing == null) {
            print('Товар не найден');
            break;
          }
          final name = InputHelper.askString('Новое название (${existing.name})');
          final price = InputHelper.askDouble('Новая цена (${existing.price})');
          final stock = InputHelper.askInt('Новое количество (${existing.stock})');
          final categoryId = InputHelper.askInt('Новый ID категории (${existing.categoryId})');
          final supplierId = InputHelper.askIntOptional('Новый ID поставщика');
          final updated = Product(
            id: id,
            name: name,
            price: price,
            stock: stock,
            categoryId: categoryId,
            supplierId: supplierId,
          );
          final errors = updated.validate();
          if (errors.isNotEmpty) {
            print('Ошибки: ${errors.join(', ')}');
          } else {
            await _productRepo.update(updated);
            print('Товар обновлён');
          }
          break;
        case 4:
          final id = InputHelper.askInt('ID товара для удаления');
          await _productRepo.delete(id);
          print('Товар удалён');
          break;
        case 0:
          return;
      }
    }
  }

  Future<void> _supplierMenu() async {
    while (true) {
      print('Поставщики');
      print('1. Список поставщиков');
      print('2. Добавить поставщика');
      print('3. Редактировать поставщика');
      print('4. Удалить поставщика');
      print('0. Назад');
      
      final choice = InputHelper.askInt('Выбор', positive: false);
      
      switch (choice) {
        case 1:
          final suppliers = await _supplierRepo.getAll();
          if (suppliers.isEmpty) {
            print('Поставщики не найдены');
          } else {
            for (var s in suppliers) print(s);
          }
          break;
        case 2:
          final name = InputHelper.askString('Название поставщика');
          final phone = InputHelper.askString('Телефон');
          final email = InputHelper.askString('Email');
          final supplier = Supplier(name: name, phone: phone, email: email);
          final errors = supplier.validate();
          if (errors.isNotEmpty) {
            print('Ошибки: ${errors.join(', ')}');
          } else {
            final id = await _supplierRepo.create(supplier);
            print('Поставщик добавлен с ID: $id');
          }
          break;
        case 3:
          final id = InputHelper.askInt('ID поставщика для редактирования');
          final existing = await _supplierRepo.getById(id);
          if (existing == null) {
            print('Поставщик не найден');
            break;
          }
          final name = InputHelper.askString('Новое название (${existing.name})');
          final phone = InputHelper.askString('Новый телефон (${existing.phone})');
          final email = InputHelper.askString('Новый email (${existing.email})');
          final updated = Supplier(id: id, name: name, phone: phone, email: email);
          final errors = updated.validate();
          if (errors.isNotEmpty) {
            print('Ошибки: ${errors.join(', ')}');
          } else {
            await _supplierRepo.update(updated);
            print('Поставщик обновлён');
          }
          break;
        case 4:
          final id = InputHelper.askInt('ID поставщика для удаления');
          await _supplierRepo.delete(id);
          print('Поставщик удалён');
          break;
        case 0:
          return;
      }
    }
  }

  Future<void> _customerMenu() async {
    while (true) {
      print('Клиенты');
      print('1. Список клиентов');
      print('2. Добавить клиента');
      print('3. Редактировать клиента');
      print('4. Удалить клиента');
      print('0. Назад');
      
      final choice = InputHelper.askInt('Выбор', positive: false);
      
      switch (choice) {
        case 1:
          final customers = await _customerRepo.getAll();
          if (customers.isEmpty) {
            print('Клиенты не найдены');
          } else {
            for (var c in customers) print(c);
          }
          break;
        case 2:
          final name = InputHelper.askString('Имя клиента');
          final email = InputHelper.askString('Email');
          final customer = Customer(name: name, email: email);
          final errors = customer.validate();
          if (errors.isNotEmpty) {
            print('Ошибки: ${errors.join(', ')}');
          } else {
            final id = await _customerRepo.create(customer);
            print('Клиент добавлен с ID: $id');
          }
          break;
        case 3:
          final id = InputHelper.askInt('ID клиента для редактирования');
          final existing = await _customerRepo.getById(id);
          if (existing == null) {
            print('Клиент не найден');
            break;
          }
          final name = InputHelper.askString('Новое имя (${existing.name})');
          final email = InputHelper.askString('Новый email (${existing.email})');
          final updated = Customer(id: id, name: name, email: email);
          final errors = updated.validate();
          if (errors.isNotEmpty) {
            print('Ошибки: ${errors.join(', ')}');
          } else {
            await _customerRepo.update(updated);
            print('Клиент обновлён');
          }
          break;
        case 4:
          final id = InputHelper.askInt('ID клиента для удаления');
          await _customerRepo.delete(id);
          print('Клиент удалён');
          break;
        case 0:
          return;
      }
    }
  }

  Future<void> _orderMenu() async {
    while (true) {
      print('Заказы');
      print('1. Список заказов');
      print('2. Добавить заказ');
      print('3. Редактировать заказ');
      print('4. Удалить заказ');
      print('0. Назад');
      
      final choice = InputHelper.askInt('Выбор', positive: false);
      
      switch (choice) {
        case 1:
          final orders = await _orderRepo.getAllWithDetails();
          if (orders.isEmpty) {
            print('Заказы не найдены');
          } else {
            for (var o in orders) {
              print('Заказ #${o['id']} | Клиент: ${o['customerName']} | '
                    'Товар: ${o['productName']} | Кол-во: ${o['quantity']} | Дата: ${o['orderDate']}');
            }
          }
          break;
        case 2:
          final customers = await _customerRepo.getAll();
          print('Доступные клиенты:');
          for (var c in customers) print(c);
          
          final products = await _productRepo.getAll();
          print('Доступные товары:');
          for (var p in products) print(p);
          
          final customerId = InputHelper.askInt('ID клиента');
          final productId = InputHelper.askInt('ID товара');
          final quantity = InputHelper.askInt('Количество');
          final orderDate = DateTime.now().toIso8601String();
          
          final order = Order(
            customerId: customerId,
            productId: productId,
            quantity: quantity,
            orderDate: orderDate,
          );
          final errors = order.validate();
          if (errors.isNotEmpty) {
            print('Ошибки: ${errors.join(', ')}');
          } else {
            final id = await _orderRepo.create(order);
            print('Заказ создан с ID: $id');
          }
          break;
        case 3:
          final id = InputHelper.askInt('ID заказа для редактирования');
          final existing = await _orderRepo.getById(id);
          if (existing == null) {
            print('Заказ не найден');
            break;
          }
          final quantity = InputHelper.askInt('Новое количество (${existing.quantity})');
          final updated = Order(
            id: id,
            customerId: existing.customerId,
            productId: existing.productId,
            quantity: quantity,
            orderDate: existing.orderDate,
          );
          await _orderRepo.update(updated);
          print('Заказ обновлён');
          break;
        case 4:
          final id = InputHelper.askInt('ID заказа для удаления');
          await _orderRepo.delete(id);
          print('Заказ удалён');
          break;
        case 0:
          return;
      }
    }
  }

  Future<void> _showAll() async {
    print('Все данные бд');
    
    print('Категории');
    final categories = await _categoryRepo.getAll();
    for (var c in categories) print(c);
    
    print('Поставщики');
    final suppliers = await _supplierRepo.getAll();
    for (var s in suppliers) print(s);
    
    print('товары');
    final products = await _productRepo.getAllWithRelations();
    for (var p in products) {
      print('ID: ${p['id']} | ${p['name']} | Цена: ${p['price']}₽ | '
            'В наличии: ${p['stock']} | Категория: ${p['categoryName'] ?? "Нет"} | '
            'Поставщик: ${p['supplierName'] ?? "Нет"}');
    }
    
    print('Клиенты');
    final customers = await _customerRepo.getAll();
    for (var c in customers) print(c);
    
    print('Заказы');
    final orders = await _orderRepo.getAllWithDetails();
    for (var o in orders) {
      print('Заказ #${o['id']} | Клиент: ${o['customerName']} | '
            'Товар: ${o['productName']} | Кол-во: ${o['quantity']} | Дата: ${o['orderDate']}');
    }
  }
}