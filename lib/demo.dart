import 'package:flutter/material.dart';

class Person {
  String name;
  int age;
  double? height;

  Person(this.name, {required this.age, this.height});
}

void main() {
  final person = Person("name", age: 30);
  final person2 = Person("Royal", age: 30, height: 1.75);
  debugPrint(person.name);
  debugPrint(person2.name);
}
