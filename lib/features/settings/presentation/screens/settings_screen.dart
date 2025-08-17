import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../features/settings/presentation/providers/settings_provider.dart';

/// Settings screen for the application
class SettingsScreen extends StatefulWidget {
  /// Default constructor
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.logScreenView(screenName: 'settings');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, _) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Theme settings
                  const Text(
                    'Appearance',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    margin: EdgeInsets.zero,
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: const Text('Dark Mode'),
                          subtitle: const Text('Use dark theme'),
                          value: settingsProvider.themeMode == ThemeMode.dark,
                          onChanged: (value) {
                            settingsProvider.setThemeMode(
                              value ? ThemeMode.dark : ThemeMode.light,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Notification settings
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    margin: EdgeInsets.zero,
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: const Text('Enable Notifications'),
                          subtitle: const Text('Receive daily reminders'),
                          value: settingsProvider.notificationsEnabled,
                          onChanged: (value) {
                            settingsProvider.setNotificationsEnabled(value);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Language settings
                  const Text(
                    'Language',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    margin: EdgeInsets.zero,
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        RadioListTile<String>(
                          title: const Text('English'),
                          value: 'en',
                          groupValue: settingsProvider.selectedLanguage,
                          onChanged: (value) {
                            if (value != null) {
                              settingsProvider.setLanguage(value);
                            }
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Spanish'),
                          value: 'es',
                          groupValue: settingsProvider.selectedLanguage,
                          onChanged: (value) {
                            if (value != null) {
                              settingsProvider.setLanguage(value);
                            }
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('French'),
                          value: 'fr',
                          groupValue: settingsProvider.selectedLanguage,
                          onChanged: (value) {
                            if (value != null) {
                              settingsProvider.setLanguage(value);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // About section
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    margin: EdgeInsets.zero,
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text('Privacy Policy'),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // Navigate to privacy policy
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          title: const Text('Terms of Service'),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // Navigate to terms of service
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          title: const Text('App Version'),
                          subtitle: const Text('1.0.0'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save button
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await settingsProvider.saveSettings();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Settings saved'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Save Settings'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
