import 'package:flutter/material.dart';

class SkillsChip extends StatelessWidget {
  final String label;

  const SkillsChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}