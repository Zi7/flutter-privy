import 'package:flutter/material.dart';

class Asset {
  final String name;
  final String symbol;
  final String balance;
  final Widget icon;
  final Widget iconLarge;

  const Asset({
    required this.name,
    required this.symbol,
    required this.balance,
    required this.icon,
    required this.iconLarge,
  });
}
