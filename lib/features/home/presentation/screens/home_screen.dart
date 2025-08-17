import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../features/ambigram/presentation/providers/ambigram_provider.dart';
import '../../../../global/state/auth_notifier.dart';
import '../widgets/background_color_picker.dart';
import '../widgets/credit_display.dart';
import '../widgets/style_selector.dart';

/// Home screen of the application where users generate ambigrams
class HomeScreen extends StatefulWidget {
  /// Default constructor
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _primaryTextController = TextEditingController();
  final _secondaryTextController = TextEditingController();
  String _selectedStyleId = 'classic';
  String _selectedBackgroundColor = '#FFFFFF';
  bool _showSecondaryInput = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService.logScreenView(screenName: 'home');
  }

  @override
  void dispose() {
    _primaryTextController.dispose();
    _secondaryTextController.dispose();
    super.dispose();
  }

  Future<void> _generateAmbigram() async {
    if (_primaryTextController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter at least one word'),
        ),
      );
      return;
    }

    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    if (authNotifier.requireLogin && authNotifier.credits <= 0) {
      _showNoCreditsDialog();
      return;
    }

    // Set values in provider
    final ambigramProvider =
        Provider.of<AmbigramProvider>(context, listen: false);
    ambigramProvider.setText(_primaryTextController.text.trim());
    ambigramProvider.setSecondaryText(
        _showSecondaryInput ? _secondaryTextController.text.trim() : null);
    ambigramProvider.setStyleId(_selectedStyleId);
    ambigramProvider.setBackgroundColor(_selectedBackgroundColor);

    // Use a credit
    if (authNotifier.requireLogin) {
      final success = await authNotifier.useCredit();
      if (!success) {
        if (mounted) {
          _showNoCreditsDialog();
        }
        return;
      }
    }

    // Generate the ambigram
    await ambigramProvider.generateAmbigram();

    // Log the event
    AnalyticsService.logAmbigramGenerated(
      primaryWord: _primaryTextController.text.trim(),
      secondaryWord:
          _showSecondaryInput ? _secondaryTextController.text.trim() : null,
      styleId: _selectedStyleId,
      backgroundColor: _selectedBackgroundColor,
    );

    // Navigate to preview screen if successful
    if (ambigramProvider.ambigramImageUrl != null && mounted) {
      context.go('/preview');
    }
  }

  void _showNoCreditsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Credits'),
        content: const Text(
            'You have run out of credits. Watch a rewarded ad to earn more credits?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _watchRewardedAd();
            },
            child: const Text('Watch Ad'),
          ),
        ],
      ),
    );
  }

  Future<void> _watchRewardedAd() async {
    // TODO: Implement rewarded ad viewing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rewarded ads coming soon!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          // Profile button
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.go('/profile');
            },
          ),
        ],
      ),
      body: Consumer<AuthNotifier>(
        builder: (context, authNotifier, _) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Credit display (if login required)
                  if (authNotifier.requireLogin) ...[
                    CreditDisplay(credits: authNotifier.credits),
                    const SizedBox(height: 16),
                  ],

                  // Primary word input
                  TextFormField(
                    controller: _primaryTextController,
                    decoration: const InputDecoration(
                      labelText: 'Primary Word',
                      hintText: 'Enter a word to convert to ambigram',
                      prefixIcon: Icon(Icons.text_fields),
                    ),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),

                  // Toggle for secondary word
                  SwitchListTile(
                    title: const Text('Add Secondary Word'),
                    subtitle: const Text(
                        'Create an ambigram with two different words'),
                    value: _showSecondaryInput,
                    onChanged: (value) {
                      setState(() {
                        _showSecondaryInput = value;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),

                  // Secondary word input (if enabled)
                  if (_showSecondaryInput) ...[
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _secondaryTextController,
                      decoration: const InputDecoration(
                        labelText: 'Secondary Word',
                        hintText: 'Enter second word for ambigram',
                        prefixIcon: Icon(Icons.text_fields),
                      ),
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Style selector
                  const Text(
                    'Select Style:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  StyleSelector(
                    selectedStyleId: _selectedStyleId,
                    onStyleSelected: (styleId) {
                      setState(() {
                        _selectedStyleId = styleId;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Background color picker
                  const Text(
                    'Select Background Color:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  BackgroundColorPicker(
                    selectedColor: _selectedBackgroundColor,
                    onColorSelected: (color) {
                      setState(() {
                        _selectedBackgroundColor = color;
                      });
                    },
                  ),
                  const SizedBox(height: 32),

                  // Generate button
                  Consumer<AmbigramProvider>(
                    builder: (context, ambigramProvider, _) {
                      return ElevatedButton(
                        onPressed: ambigramProvider.isLoading
                            ? null
                            : _generateAmbigram,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: ambigramProvider.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Generate Ambigram'),
                      );
                    },
                  ),
                  
                  // Demo button
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => context.go('/preview-demo'),
                    icon: const Icon(Icons.science_outlined),
                    label: const Text('Try Ambigram Preview Demo'),
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
