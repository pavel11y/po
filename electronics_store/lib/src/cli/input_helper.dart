import 'dart:io';
import '../domain/validators/text_validator.dart';
import '../domain/validators/number_validator.dart';

class InputHelper {
  static String askString(String prompt, {bool required = true}) {
    while (true) {
      stdout.write('$prompt: ');
      final input = stdin.readLineSync() ?? '';
      
      if (!required) return input;
      
      final error = validateRequired(input, prompt);
      if (error == null) return input;
      print('Ошибка: $error');
    }
  }

  static double askDouble(String prompt, {bool positive = true}) {
    while (true) {
      stdout.write('$prompt: ');
      final input = stdin.readLineSync() ?? '';
      
      final double? value = double.tryParse(input);
      if (value == null) {
        print('Ошибка: Введите число');
        continue;
      }
      
      if (positive) {
        final error = validatePositive(value, prompt);
        if (error == null) return value;
        print('Ошибка: $error');
      } else {
        return value;
      }
    }
  }

  static int askInt(String prompt, {bool positive = true}) {
    while (true) {
      stdout.write('$prompt: ');
      final input = stdin.readLineSync() ?? '';
      
      final int? value = int.tryParse(input);
      if (value == null) {
        print('Ошибка: Введите целое число');
        continue;
      }
      
      if (positive) {
        final error = validatePositive(value, prompt);
        if (error == null) return value;
        print('Ошибка: $error');
      } else {
        return value;
      }
    }
  }

  static int? askIntOptional(String prompt) {
    stdout.write('$prompt (оставьте пустым для пропуска): ');
    final input = stdin.readLineSync() ?? '';
    if (input.trim().isEmpty) return null;
    return int.tryParse(input);
  }
}