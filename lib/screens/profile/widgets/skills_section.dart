import 'package:flutter/material.dart';

class SkillsSection extends StatelessWidget {
  final List<String> skills;
  final bool isEditable;
  final VoidCallback? onEdit;
  
  const SkillsSection({
    super.key,
    required this.skills,
    this.isEditable = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty && !isEditable) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Skills',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (isEditable)
              TextButton(
                onPressed: onEdit,
                child: const Text('Edit'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (skills.isEmpty)
          const Text('No skills added yet')
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((skill) {
              return Chip(
                label: Text(skill),
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              );
            }).toList(),
          ),
      ],
    );
  }
}