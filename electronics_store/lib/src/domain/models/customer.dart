import '../validators/text_validator.dart';

class Customer {
  int? id;
  String name;
  String email;

  Customer({this.id, required this.name, required this.email});

  List<String> validate() {
    final errors = <String>[];
    final nameError = validateRequired(name, 'Имя клиента');
    if (nameError != null) errors.add(nameError);
    final emailError = validateRequired(email, 'Email');
    if (emailError != null) errors.add(emailError);
    return errors;
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email};
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      email: map['email'],
    );
  }

  @override
  String toString() => 'ID: $id | $name | Email: $email';
}