import '../validators/text_validator.dart';
import '../validators/number_validator.dart';

class Supplier {
  int? id;
  String name;
  String phone;
  String email;

  Supplier({this.id, required this.name, required this.phone, required this.email});

  List<String> validate() {
    final errors = <String>[];
    final nameError = validateRequired(name, 'Название поставщика');
    if (nameError != null) errors.add(nameError);
    final phoneError = validateRequired(phone, 'Телефон');
    if (phoneError != null) errors.add(phoneError);
    final emailError = validateRequired(email, 'Email');
    if (emailError != null) errors.add(emailError);
    return errors;
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'phone': phone, 'email': email};
  }

  factory Supplier.fromMap(Map<String, dynamic> map) {
    return Supplier(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
    );
  }

  @override
  String toString() => 'ID: $id | $name | Тел: $phone | Email: $email';
}