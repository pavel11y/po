bool isNotEmptyString(String? value) {
  return value != null && value.trim().isNotEmpty;
}

String? validateRequired(String? value, String fieldName) {
  if (!isNotEmptyString(value)) {
    return '$fieldName не может быть пустым';
  }
  return null;
}