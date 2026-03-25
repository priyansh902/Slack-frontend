import 'package:flutter/material.dart';

class BioSection extends StatelessWidget {
  final String bio;
  final bool isEditable;
  final VoidCallback? onEdit;
  
  const BioSection({
    super.key,
    required this.bio,
    this.isEditable = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    if (bio.isEmpty && !isEditable) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'About',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (isEditable)
              TextButton(
                onPressed: onEdit,
                child: const Text('Edit'),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (bio.isEmpty)
          const Text('No bio added yet')
        else
          Text(
            bio,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
      ],
    );
  }
}