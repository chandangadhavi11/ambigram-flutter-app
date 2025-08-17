import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../global/state/auth_notifier.dart';
import '../widgets/profile_menu_item.dart';

/// Profile screen for the application
class ProfileScreen extends StatefulWidget {
  /// Default constructor
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.logScreenView(screenName: 'profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profile),
      ),
      body: Consumer<AuthNotifier>(
        builder: (context, authNotifier, _) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile header
                  _buildProfileHeader(context, authNotifier),
                  const SizedBox(height: 24),

                  // Menu items
                  ProfileMenuItem(
                    icon: Icons.star_outline,
                    title: 'Credits',
                    subtitle: 'Manage your credits',
                    onTap: () {
                      // Show credits dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Credits'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  'You have ${authNotifier.credits} credits remaining.'),
                              const SizedBox(height: 16),
                              const Text(
                                'Credits are used to generate ambigrams. '
                                'You can earn more credits by watching rewarded ads '
                                'or by purchasing them.',
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                // TODO: Implement get more credits
                              },
                              child: const Text('Get More'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  ProfileMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    subtitle: 'App preferences and theme',
                    onTap: () {
                      // Navigate to settings
                      context.go('/settings');
                    },
                  ),

                  ProfileMenuItem(
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'App info and help',
                    onTap: () {
                      // Show about dialog
                      showAboutDialog(
                        context: context,
                        applicationName: AppStrings.appName,
                        applicationVersion: '1.0.0',
                        applicationIcon: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              'A',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text(
                              'Create beautiful ambigrams that can be read the same '
                              'when turned upside down.',
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  // Authentication buttons removed
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, AuthNotifier authNotifier) {
    return Column(
      children: [
        // Avatar
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary,
              width: 2,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.person,
              size: 60,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // User name - always show guest
        Text(
          AppStrings.guest,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),

        // Credits badge - always show credits
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.star,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '${authNotifier.credits} Credits',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
