import 'package:flutter/material.dart';
import 'package:phoenix_slack/data/model/project/project.dart';

class ProjectSearchCard extends StatelessWidget {
  final Project project;
  
  const ProjectSearchCard({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.code, size: 32),
        title: Text(project.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('by @${project.username}'),
            if (project.techStackList.isNotEmpty)
              Wrap(
                spacing: 4,
                children: project.techStackList.map((tech) {
                  return Chip(
                    label: Text(tech),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                  );
                }).toList(),
              ),
          ],
        ),
        onTap: () {
          // Navigate to project detail
        },
      ),
    );
  }
}