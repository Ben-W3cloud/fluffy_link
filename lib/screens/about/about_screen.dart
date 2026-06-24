import 'package:fluffy_link/core/page_scaffold.dart';
import 'package:fluffy_link/core/theme.dart';
import 'package:fluffy_link/core/ui_components.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return PageScaffold(
      currentRoute: '/about',
      child: Column(
        children: [
          // Hero
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? AppTheme.spaceLg : 64,
              vertical: isMobile ? AppTheme.spaceXl : 80,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primary.withValues(alpha: 0.08),
                  AppTheme.background,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border(
                bottom: BorderSide(color: AppTheme.border),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                    border: Border.all(
                      color: AppTheme.primary.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Text(
                    'ABOUT',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spaceMd),
                Text(
                  'About Perma.link',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppTheme.spaceMd),
                SizedBox(
                  width: isMobile ? double.infinity : 600,
                  child: Text(
                    "We're building a permanent, decentralized link shortener on Walrus. Your files, your control, forever.",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.muted,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? AppTheme.spaceLg : 64,
              vertical: isMobile ? AppTheme.spaceXl : 80,
            ),
            child: Column(
              children: [
                _Section(
                  title: 'Our Mission',
                  content:
                      'Create a censorship-resistant, permanent URL shortener backed by decentralized storage. No account needed. No tracking. Pure links.',
                  isMobile: isMobile,
                ),
                const SectionDivider(label: 'BUILT ON'),
                GridView.count(
                  crossAxisCount: isMobile ? 1 : 3,
                  crossAxisSpacing: AppTheme.spaceLg,
                  mainAxisSpacing: AppTheme.spaceLg,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: isMobile ? 3.4 : 1.45,
                  children: const [
                    _GlassInfoCard(
                      title: 'Flutter Web',
                      description: 'Cross-platform, beautiful UI',
                      icon: Icons.devices,
                    ),
                    _GlassInfoCard(
                      title: 'Walrus Storage',
                      description: 'Decentralized & immutable',
                      icon: Icons.cloud_queue,
                    ),
                    _GlassInfoCard(
                      title: 'Supabase',
                      description: 'Fast metadata + analytics',
                      icon: Icons.storage,
                    ),
                  ],
                ),
                const SectionDivider(label: 'FEATURES'),
                GridView.count(
                  crossAxisCount: isMobile ? 1 : 2,
                  crossAxisSpacing: AppTheme.spaceLg,
                  mainAxisSpacing: AppTheme.spaceLg,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: isMobile ? 3.6 : 2.2,
                  children: const [
                    _GlassFeatureCard(
                      title: 'One-Click Sharing',
                      description:
                          'Upload, get a link, share instantly. No friction.',
                      icon: Icons.share,
                    ),
                    _GlassFeatureCard(
                      title: 'Permanent Storage',
                      description:
                          'Your files live on Walrus forever—no expiry.',
                      icon: Icons.lock,
                    ),
                    _GlassFeatureCard(
                      title: 'Analytics',
                      description:
                          'Track link clicks without invading privacy.',
                      icon: Icons.bar_chart,
                    ),
                    _GlassFeatureCard(
                      title: 'No Account',
                      description:
                          'Anonymous sharing—zero personal data required.',
                      icon: Icons.person_off,
                    ),
                  ],
                ),
                const SectionDivider(label: 'ROADMAP'),
                const _RoadmapItem(
                  phase: 'Phase 1 (Live)',
                  title: 'Core Upload & Redirect',
                  description:
                      'Simple file upload, short URL generation, and instant redirect.',
                  isActive: true,
                ),
                const _RoadmapItem(
                  phase: 'Phase 2 (Q3 2026)',
                  title: 'Custom Domains',
                  description:
                      'Attach your own domain to short links. Brand your shares.',
                ),
                const _RoadmapItem(
                  phase: 'Phase 3 (Q4 2026)',
                  title: 'Link Expiry & Passwords',
                  description:
                      'Optional expiry dates and access passwords for premium users.',
                ),
                const _RoadmapItem(
                  phase: 'Phase 4 (2027)',
                  title: 'Batch Uploads & Teams',
                  description:
                      'Collaborative link management and bulk sharing workflows.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.content,
    required this.isMobile,
  });

  final String title;
  final String content;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isMobile ? 40 : 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppTheme.spaceMd),
          SizedBox(
            width: isMobile ? double.infinity : 700,
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.muted,
                height: 1.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassInfoCard extends StatelessWidget {
  const _GlassInfoCard({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      decoration: AppTheme.gradientCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primary, size: 28),
          const SizedBox(height: AppTheme.spaceMd),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spaceXs),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassFeatureCard extends StatelessWidget {
  const _GlassFeatureCard({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      decoration: AppTheme.gradientCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spaceSm),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              border: Border.all(
                color: AppTheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Icon(icon, color: AppTheme.primary, size: 24),
          ),
          const SizedBox(height: AppTheme.spaceMd),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spaceXs),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoadmapItem extends StatelessWidget {
  const _RoadmapItem({
    required this.phase,
    required this.title,
    required this.description,
    this.isActive = false,
  });

  final String phase;
  final String title;
  final String description;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spaceLg),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        decoration: AppTheme.glassCard(
          borderColor: isActive
              ? AppTheme.primary.withValues(alpha: 0.45)
              : null,
        ).copyWith(
          boxShadow: isActive
              ? AppTheme.glowShadow(opacity: 0.12, blur: 22)
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive ? AppTheme.primary : AppTheme.border,
                  width: 2,
                ),
                boxShadow: isActive
                    ? AppTheme.glowShadow(opacity: 0.35, blur: 12)
                    : null,
              ),
              child: Center(
                child: isActive
                    ? const Icon(
                        Icons.check,
                        color: AppTheme.primary,
                        size: 20,
                      )
                    : Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppTheme.border,
                          shape: BoxShape.circle,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: AppTheme.spaceLg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    phase,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: isActive ? AppTheme.primary : AppTheme.muted,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceXs),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
