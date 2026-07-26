import 'package:flutter/material.dart';

/// Display model for a single stat tile on the profile screen (e.g. streak).
class ProfileStatModel {
  final IconData icon;
  final String value;
  final String label;

  const ProfileStatModel({
    required this.icon,
    required this.value,
    required this.label,
  });
}
