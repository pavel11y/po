# electronics_store — модульное CLI-приложение на Dart

Консольное приложение для управления складом интернет-магазина электроники с хранением данных в JSON файле.

## Предметная область

Система автоматизации склада электроники:

- категории товаров (`Category`);
- товары (`Product`) с привязкой к категории и поставщику;
- поставщики (`Supplier`);
- клиенты (`Customer`);
- заказы (`Order`) с привязкой к клиенту и товару.

## Архитектура и структура папок

Проект разделен на модули по слоям:

```text
lib/
  electronics_store.dart      # публичный экспорт
  src/
    domain/                   # сущности и валидаторы
      models/
        category.dart
        product.dart
        supplier.dart
        customer.dart
        order.dart
      validators/
        text_validator.dart
        number_validator.dart
    data/                     # JSON хранилище и CRUD-логика
      database.dart
      repositories/
        category_repository.dart
        product_repository.dart
        supplier_repository.dart
        customer_repository.dart
        order_repository.dart
    cli/                      # меню и обработка ввода
      menu.dart
      input_helper.dart
bin/
  main.dart                   # точка входа
test/
  validation_test.dart        # тесты валидации
  domain_test.dart            # тесты сущностей (toMap/fromMap)
  data_test.dart              # тесты БД (вставка/чтение)