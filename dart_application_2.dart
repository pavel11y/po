String formatName(String firstName, String lastName, [String? middleName]) {
  if (middleName != null && middleName.isNotEmpty) {
    return "$lastName $middleName $firstName";
  }
  return "$lastName $firstName";
}

double? calculate(double a, double b, String op) {
  switch (op) {
    case "+":
      return a + b;
    case "-":
      return a - b;
    case "*":
      return a * b;
    case "/": 
      if(b==0){
        return null;
      }
      return a/b;
  }
}

void countSigns(List<int> numbers) {
  int poloz = 0;
  int otrich = 0; 
  int nulll = 0;
  
  for (int num in numbers) {
    if (num > 0) {
      poloz++;
    }
    else if (num < 0) {
      otrich++;
      }
    else {
      nulll++;
    }
  }
  
  print("Положительных: $poloz");
  print("Отрицательных: $otrich");
  print("Нулевых: $nulll");
}

List<int> transformList(List<int> numbers, int Function(int) transformer) {
  List<int> result = [];
  for (int num in numbers) {
    result.add(transformer(num));
  }
  return result;
}

int sumDigits(int n) {
  if (n < 10) return n;
  return (n % 10) + sumDigits(n ~/ 10);
}
void main() {
  print("Задание 1");
  print(formatName("Иванов", "Иван"));
  print(formatName("Иванов", "Иван", "Иванович"));

  print("Задание 2");
  print(calculate(10, 5, "+"));
  print(calculate(10, 0, "/"));
  
  print("Задание 3");
  List<int> nums = [5, -3, 0, 12, -7, 0, 8, -1, 0, 4];
  countSigns(nums);
  
  print("Задание 4");
  List<int> numbers = [1, 2, 3, 4, 5];
  print("Исходный список: $numbers");
  print("Удвоенный: ${transformList(numbers, (x) => x * 2)}");
  
  print("Задание 5");
  print("Сумма цифр числа 123456789: ${sumDigits(123456789)}");
}
