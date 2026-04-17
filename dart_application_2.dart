import 'dart:convert' ;
import 'package:characters/characters.dart' ;
import 'dart:io' ;

void main () {
  print ('Введите эмодзи:' );
  String em = stdin.readLineSync (encoding : utf8) !;
  print (em);
  print (em.runes);
  print (em.runes.length);
  print (em.runes.first.toRadixString ( 16 ));
  print (em.runes.first.toRadixString ( 16 ).length);
  print (em.codeUnits);
  print (em.characters.length);
}
