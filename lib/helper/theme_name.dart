import 'package:flutter/material.dart';

extension ColorName on BuildContext {
  Color get primary => Theme.of(this).colorScheme.primary;
  Color get secondary => Theme.of(this).colorScheme.secondary;
  Color get surface => Theme.of(this).colorScheme.surface;
  Color get tertiary => Theme.of(this).colorScheme.tertiary;
  Color get inversePrimary => Theme.of(this).colorScheme.inversePrimary;
}
