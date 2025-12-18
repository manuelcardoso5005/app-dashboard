import 'package:flutter/material.dart';

IconData getIcon(int index) {
  final icons = [
    Icons.dashboard,
    Icons.analytics,
    Icons.shopping_bag,
    Icons.receipt_long,
    Icons.people,
    Icons.settings,
    Icons.person,
  ];
  return icons[index];
}
