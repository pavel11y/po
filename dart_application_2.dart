import 'dart:io';
import 'dart:math';

void main(List <String> argouments){
  print('Введите первое число');
  var num = double.parse(stdin.readLineSync()!);
  
  print('Введите второе число');
  var num2 = double.parse(stdin.readLineSync()!);
  
  print('Введите оператор');
  String op = stdin.readLineSync()!;

  switch (op) {
    case '+':
      print(num + num2);
      break;
    case '-':
      print(num - num2);
      break;
    case '*':
      print(num * num2);
      break;
    case '/':
      if (num2 == 0) {
        print('Нельзя делить на 0');
      } else {
        print(num / num2);
      }
      break;
    case '~/':
      if (num2 == 0) {
        print('Нельзя делить на 0');
      } else {
        print(num ~/ num2);
      }
      break;
    case '%':
      if (num2 == 0) {
        print('Нельзя делить на 0');
      } else {
        print(num % num2);
      }
      break;
    case '**':
      print(pow(num, num2));
      break;
    case '==':
      print(num == num2);
      break;
    case '!=':
      print(num != num2);
      break;
    case '>':
      print(num > num2);
      break;
    case '<':
      print(num < num2);
      break;
    case '>=':
      print(num >= num2);
      break;
    case '<=':
      print(num <= num2);
      break;
    default:
      print('Неизвестный оператор');
      break;
  }

  bool b1 = bool.parse(stdin.readLineSync()?.toLowerCase() ?? '');
  bool b2 = bool.parse(stdin.readLineSync()?.toLowerCase() ?? '');
  String opl = stdin.readLineSync()!;

  switch (opl) {
    case '1':
      print(b1 && b2);
      break;
    case '2':
      print(b1 || b2);
      break;
    case '3':
      print(!b1);
      print(!b2);
      break;
    default:
      print('Неизвестная операция');
      break;
  }
}
