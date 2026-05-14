bool isPositiveNumber(num value) {
  return value > 0;
}

String? validatePositive(num? value, String fieldName) {
  if (value == null || !isPositiveNumber(value)) {
    return '$fieldName должно быть больше 0';
  }
  return null;
}