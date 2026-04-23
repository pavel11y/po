import 'dart:math';

// 1
class Cup {
  int water;
  Cup(this.water);
  void drink(int amount) {
    if (amount <= water) {
      water -= amount;
      print('Выпито $amount мл. Осталось $water мл.');
    } else {
      print('Недостаточно воды!');
    }
  }
}

class Human {
  final String name;
  Human(this.name);
  void drinkFromCup(Cup cup, int amount) {
    print('$name пьет из кружки...');
    cup.drink(amount);
  }
}

// 2
class StorageSystem {
  final Map<String, dynamic> _items = {};
  
  void put(String key, dynamic item) {
    _items[key] = item;
    print('Вещь "$key" положена');
  }
  
  dynamic take(String key) {
    return _items.remove(key);
  }
}

class Wardrobe {
  final List<StorageSystem> _storages = [];
  
  void addStorageSystem(StorageSystem storage) {
    _storages.add(storage);
  }
  
  void putItem(String key, dynamic item, int index) {
    if (index < _storages.length) {
      _storages[index].put(key, item);
    }
  }
  
  dynamic takeItem(String key, int index) {
    if (index < _storages.length) {
      return _storages[index].take(key);
    }
    return null;
  }
}

// 3
class BarbellPlate {
  final double weight;
  BarbellPlate(this.weight);
}

class Barbell {
  final double maxLoad;
  final List<BarbellPlate> _leftPlates = [];
  final List<BarbellPlate> _rightPlates = [];
  double _currentWeight = 0;
  
  Barbell(this.maxLoad);
  
  void addLeft(BarbellPlate plate) {
    if (_currentWeight + plate.weight <= maxLoad) {
      _leftPlates.add(plate);
      _currentWeight += plate.weight;
      print('Блин ${plate.weight}кг слева. Общий вес: $_currentWeight кг');
    } else {
      print('Превышение максимальной нагрузки!');
    }
  }
  
  void addRight(BarbellPlate plate) {
    if (_currentWeight + plate.weight <= maxLoad) {
      _rightPlates.add(plate);
      _currentWeight += plate.weight;
      print('Блин ${plate.weight}кг справа. Общий вес: $_currentWeight кг');
    } else {
      print('Превышение максимальной нагрузки!');
    }
  }
  
  double get weight => _currentWeight;
}

// 4
class CurrencyConverter {
  final Map<String, double> _rates = {
    'USD': 1.0,
    'EUR': 0.85,
    'RUB': 75.0,
    'GBP': 0.73,
  };
  
  void setRate(String currency, double rateToUSD) {
    _rates[currency] = rateToUSD;
  }
  
  double convert(double amount, String from, String to) {
    double inUSD = amount / _rates[from]!;
    double result = inUSD * _rates[to]!;
    return result;
  }
}

// 5
class Garage<T> {
  final List<T> _items = [];
  
  void add(T item) {
    _items.add(item);
    print('Добавлен объект типа ${T.toString()}');
  }
  
  T? remove(int index) {
    if (index < _items.length) {
      return _items.removeAt(index);
    }
    return null;
  }
  
  List<T> getAll() {
    return List.from(_items);
  }
}

// 6
class Vector {
  final double x;
  final double y;
  
  Vector(this.x, this.y);
  
  Vector operator +(Vector other) {
    return Vector(x + other.x, y + other.y);
  }
  
  Vector operator -(Vector other) {
    return Vector(x - other.x, y - other.y);
  }
  
  Vector operator *(double scalar) {
    return Vector(x * scalar, y * scalar);
  }
  
  Vector operator /(double scalar) {
    return Vector(x / scalar, y / scalar);
  }
  
  Vector operator -() {
    return Vector(-x, -y);
  }
  
  @override
  String toString() {
    return 'Vector($x, $y)';
  }
}

// 7
enum CarState { stop, moving, turning }
enum TurnDirection { left, right }

class Car {
  CarState _state = CarState.stop;
  TurnDirection? _turnDirection;
  
  void start() {
    _state = CarState.moving;
    print('Автомобиль начал движение');
  }
  
  void stop() {
    _state = CarState.stop;
    _turnDirection = null;
    print('Автомобиль остановился');
  }
  
  void turn(TurnDirection direction) {
    if (_state == CarState.moving) {
      _state = CarState.turning;
      _turnDirection = direction;
      String dir = direction == TurnDirection.left ? 'налево' : 'направо';
      print('Автомобиль поворачивает $dir');
    } else {
      print('Для поворота автомобиль должен двигаться');
    }
  }
  
  CarState get state => _state;
  TurnDirection? get turnDirection => _turnDirection;
}

// 8
abstract class GeometricFigure {
  double get area;
  double get perimeter;
}

class Rectangle extends GeometricFigure {
  final double width;
  final double height;
  
  Rectangle(this.width, this.height);
  
  @override
  double get area => width * height;
  
  @override
  double get perimeter => 2 * (width + height);
}

class Circle extends GeometricFigure {
  final double radius;
  
  Circle(this.radius);
  
  @override
  double get area => pi * radius * radius;
  
  @override
  double get perimeter => 2 * pi * radius;
}

class Triangle extends GeometricFigure {
  final double sideA;
  final double sideB;
  final double sideC;
  
  Triangle(this.sideA, this.sideB, this.sideC);
  
  @override
  double get area {
    double s = (sideA + sideB + sideC) / 2;
    return sqrt(s * (s - sideA) * (s - sideB) * (s - sideC));
  }
  
  @override
  double get perimeter => sideA + sideB + sideC;
}

// 9
class NumberBaseConverter {
  static String fromDecimal(int number, int base) {
    return number.toRadixString(base).toUpperCase();
  }
  
  static int toDecimal(String number, int base) {
    return int.parse(number, radix: base);
  }
  
  static String convert(String number, int fromBase, int toBase) {
    int decimal = toDecimal(number, fromBase);
    return fromDecimal(decimal, toBase);
  }
}

// 10
class FigureCollection {
  final List<GeometricFigure> _figures = [];
  
  void add(GeometricFigure figure) {
    _figures.add(figure);
  }
  
  GeometricFigure? getMaxAreaFigure() {
    if (_figures.isEmpty) {
      return null;
    }
    
    GeometricFigure maxFigure = _figures[0];
    for (GeometricFigure figure in _figures) {
      if (figure.area > maxFigure.area) {
        maxFigure = figure;
      }
    }
    return maxFigure;
  }
  
  List<GeometricFigure> get figures => List.from(_figures);
}

// 11
abstract class Cutlery {
  final String name;
  
  Cutlery(this.name);
  
  void use() {
    print('Используется $name');
  }
}

class Fork extends Cutlery {
  Fork() : super('Вилка');
}

class Spoon extends Cutlery {
  Spoon() : super('Ложка');
}

class Knife extends Cutlery {
  Knife() : super('Нож');
}

class Table {
  final List<Cutlery> _cutleryOnTable = [];
  
  void putOnTable(Cutlery cutlery) {
    _cutleryOnTable.add(cutlery);
    print('${cutlery.name} поставлен(а) на стол');
  }
  
  void removeFromTable(Cutlery cutlery) {
    // Ищем прибор с таким же названием
    Cutlery? found = _cutleryOnTable.firstWhere(
      (item) => item.name == cutlery.name,
      orElse: () => null as Cutlery,
    );
    
    if (found != null) {
      _cutleryOnTable.remove(found);
      print('${cutlery.name} убран(а) со стола');
    } else {
      print('${cutlery.name} не найден(а) на столе');
    }
  }
  
  // Альтернативный вариант - удаление по индексу или имени
  void removeByName(String name) {
    Cutlery? found = _cutleryOnTable.firstWhere(
      (item) => item.name == name,
      orElse: () => null as Cutlery,
    );
    
    if (found != null) {
      _cutleryOnTable.remove(found);
      print('$name убран(а) со стола');
    } else {
      print('$name не найден(а) на столе');
    }
  }
  
  void showAllCutlery() {
    print('На столе приборы:');
    for (Cutlery cutlery in _cutleryOnTable) {
      print('- ${cutlery.name}');
    }
  }
}
void main() {
  print('1');
  Cup cup = Cup(500);
  Human human = Human('Иван');
  human.drinkFromCup(cup, 200);
  
  print('2');
  Wardrobe wardrobe = Wardrobe();
  wardrobe.addStorageSystem(StorageSystem());
  wardrobe.putItem('Книга', 'Война и мир', 0);
  wardrobe.takeItem('Книга', 0);
  
  print('3');
  Barbell barbell = Barbell(200);
  barbell.addLeft(BarbellPlate(20));
  barbell.addRight(BarbellPlate(20));
  
  print('4');
  CurrencyConverter converter = CurrencyConverter();
  double result = converter.convert(100, 'USD', 'EUR');
  print('100 USD = $result EUR');
  
  print('5');
  Garage<Car> carGarage = Garage();
  carGarage.add(Car());
  
  print('6');
  Vector v1 = Vector(3, 4);
  Vector v2 = Vector(1, 2);
  print('$v1 + $v2 = ${v1 + v2}');
  
  print('7');
  Car car = Car();
  car.start();
  car.turn(TurnDirection.left);
  car.stop();
  
  print('8');
  Rectangle rect = Rectangle(5, 3);
  Circle circle = Circle(4);
  print('Площадь прямоугольника: ${rect.area}');
  print('Площадь круга: ${circle.area}');
  
  print('9');
  String hex = NumberBaseConverter.fromDecimal(255, 16);
  print('255 в 16-чной: $hex');
  int dec = NumberBaseConverter.toDecimal('FF', 16);
  print('FF в 10-чной: $dec');
  
  print('10');
  FigureCollection collection = FigureCollection();
  collection.add(Rectangle(10, 5));
  collection.add(Circle(3));
  collection.add(Triangle(3, 4, 5));
  GeometricFigure? maxFigure = collection.getMaxAreaFigure();
  print('Максимальная площадь: ${maxFigure?.area}');
  
  print('11');
  Table table = Table();
  Fork fork = Fork();
  Spoon spoon = Spoon();
  table.putOnTable(fork);
  table.putOnTable(spoon);
  table.showAllCutlery();
  table.removeFromTable(fork);
  table.showAllCutlery();
}