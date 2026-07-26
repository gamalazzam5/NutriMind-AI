import 'package:flutter/material.dart';

/// Display model for a single macro progress chip (Protein / Carbs / Fat).
class MacroModel {
  final String label;
  final double current;
  final double target;
  final String unit;
  final Color color;

  const MacroModel({
    required this.label,
    required this.current,
    required this.target,
    required this.unit,
    required this.color,
  });

  double get progress => target == 0 ? 0 : (current / target).clamp(0, 1);
}
