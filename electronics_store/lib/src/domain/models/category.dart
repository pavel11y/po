import '../validators/text_validator.dart';

class Category {
  int? id;
  String name;
  String description;

  Category({this.id, required this.name, required this.description});

  List<String> validate() {
    final errors = <String>[];
    final nameError = validateRequired(name, 'Название категории');
    if (nameError != null) errors.add(nameError);
    final descError = validateRequired(description, 'Описание');
    if (descError != null) errors.add(descError);
    return errors;
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'description': description};
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }

  @override
  String toString() => 'ID: $id | $name - $description';
}