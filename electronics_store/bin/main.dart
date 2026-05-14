import 'package:electronics_store/electronics_store.dart';

void main() async {
  await initDatabase();
  
  final menu = Menu();
  await menu.run();
}