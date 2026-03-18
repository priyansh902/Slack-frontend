import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/portfolio_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/project_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import 'widgets/portfolio_header.dart';
import 'widgets/skills_chip.dart';
import 'widgets/project_tile.dart';
import 'widgets/resume_button.dart';

class PublicPortfolioScreen extends StatefulWidget {
  final String username;

  const PublicPortfolioScreen({super.key, required this.username});

  @override
  State<PublicPortfolioScreen> createState() => _PublicPortfolioScreenState();
}

class _PublicPortfolioScreenState extends State<PublicPortfolioScreen> {
  @override
  void initState() {
    super.initState();
    _loadPortfolio();
  }

  Future<void> _loadPortfolio() async {
    final portfolioProvider = Provider.of<PortfolioProvider>(context, listen: false);
    await portfolioProvider.loadPortfolio(widget.username);
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final portfolioProvider = Provider.of<PortfolioProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('@${widget.username}'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share portfolio link
            },
          ),
        ],
      ),
      body: portfolioProvider.isLoading
          ? const LoadingIndicator()
          : portfolioProvider.error != null
              ? CustomErrorWidget(
                  message: portfolioProvider.error!,
                  onRetry: _loadPortfolio,
                )
              : portfolioProvider.portfolio == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.person_off,
                            size: 80,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No portfolio found for @${widget.username}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadPortfolio,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            PortfolioHeader(
                              name: portfolioProvider.portfolio!.name,
                              username: portfolioProvider.portfolio!.username,
                              bio: portfolioProvider.portfolio!.bio,
                              memberSince: portfolioProvider.portfolio!.memberSince,
                            ),
                            const SizedBox(height: 24),

                            // Skills Section
                            if (portfolioProvider.portfolio!.skills.isNotEmpty) ...[
                              const Text(
                                'Skills',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: portfolioProvider.portfolio!.skills
                                    .map((skill) => SkillsChip(label: skill))
                                    .toList(),
                              ),
                              const SizedBox(height: 24),
                            ],

                            // Social Links
                            if (portfolioProvider.portfolio!.githubUrl != null ||
                                portfolioProvider.portfolio!.linkedinUrl != null) ...[
                              const Text(
                                'Connect',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  if (portfolioProvider.portfolio!.githubUrl != null)
                                    _buildSocialButton(
                                      'GitHub',
                                      Icons.code,
                                      portfolioProvider.portfolio!.githubUrl!,
                                    ),
                                  if (portfolioProvider.portfolio!.linkedinUrl != null)
                                    _buildSocialButton(
                                      'LinkedIn',
                                      Icons.business,
                                      portfolioProvider.portfolio!.linkedinUrl!,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 24),
                            ],

                            // Projects Section
                            const Text(
                              'Projects',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...portfolioProvider.portfolio!.projects.map(
                              (project) => ProjectTile(
                                project: project,
                                onTap: () => _showProjectDialog(project),
                              ),
                            ),

                            // Resume Button
                            if (portfolioProvider.portfolio!.resumeUrl != null) ...[
                              const SizedBox(height: 24),
                              ResumeButton(
                                resumeUrl: portfolioProvider.portfolio!.resumeUrl!,
                                onPressed: () => _launchUrl(
                                  portfolioProvider.portfolio!.resumeUrl!,
                                ),
                              ),
                            ],

                            const SizedBox(height: 16),
                            Center(
                              child: Text(
                                'Last updated: ${_formatDate(portfolioProvider.portfolio!.lastUpdated)}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
    );
  }

  Widget _buildSocialButton(String label, IconData icon, String url) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton.icon(
        onPressed: () => _launchUrl(url),
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(120, 40),
        ),
      ),
    );
  }

  void _showProjectDialog(dynamic project) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(project.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(project.description),
            const SizedBox(height: 8),
            Text('Tech: ${project.techStack}'),
          ],
        ),
        actions: [
          if (project.githubLink != null)
            TextButton(
              onPressed: () => _launchUrl(project.githubLink!),
              child: const Text('GitHub'),
            ),
          if (project.liveLink != null)
            TextButton(
              onPressed: () => _launchUrl(project.liveLink!),
              child: const Text('Live Demo'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}