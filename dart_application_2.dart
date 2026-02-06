import 'dart:io';
import 'dart:math';

void main(List <String> argouments){
  

  
  

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
