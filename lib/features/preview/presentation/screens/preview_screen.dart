import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../features/ambigram/presentation/providers/ambigram_provider.dart';
import '../widgets/action_button.dart';
import '../widgets/preview_image.dart';

/// Screen to preview and share generated ambigrams
class PreviewScreen extends StatefulWidget {
  /// Primary word for the ambigram (for direct navigation)
  final String? primaryWord;

  /// Secondary word for the ambigram (for direct navigation)
  final String? secondaryWord;

  /// Style ID for the ambigram (for direct navigation)
  final String? styleId;

  /// Background color for the ambigram (for direct navigation)
  final String? backgroundColor;

  /// SVG data for the ambigram (for direct navigation)
  final String? svgData;

  /// Default constructor
  const PreviewScreen({
    super.key,
    this.primaryWord,
    this.secondaryWord,
    this.styleId,
    this.backgroundColor,
    this.svgData,
  });

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  bool _isSaving = false;
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService.logScreenView(screenName: 'preview');
    _initialize();
  }

  Future<void> _initialize() async {
    final ambigramProvider =
        Provider.of<AmbigramProvider>(context, listen: false);

    // If direct navigation with data, set the data in the provider
    if (widget.primaryWord != null && widget.primaryWord!.isNotEmpty) {
      ambigramProvider.setText(widget.primaryWord!);
      ambigramProvider.setSecondaryText(widget.secondaryWord);
      ambigramProvider.setStyleId(widget.styleId ?? 'classic');
      ambigramProvider.setBackgroundColor(widget.backgroundColor ?? '#FFFFFF');

      // If SVG data provided directly, use it
      if (widget.svgData != null) {
        ambigramProvider
            .setAmbigramImageUrl('data:image/svg+xml;base64,${widget.svgData}');
      }
    }

    ambigramProvider.setPreviewMode(true);
  }

  Future<void> _saveAmbigram() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final ambigramProvider =
          Provider.of<AmbigramProvider>(context, listen: false);
      final success = await ambigramProvider.saveAmbigram();

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ambigram saved to gallery')),
          );

          AnalyticsService.logAmbigramShared(
            action: 'save',
            primaryWord: ambigramProvider.text,
            secondaryWord: ambigramProvider.secondaryText,
            styleId: ambigramProvider.styleId,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save ambigram'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _shareAmbigram() async {
    if (_isSharing) return;

    setState(() {
      _isSharing = true;
    });

    try {
      final ambigramProvider =
          Provider.of<AmbigramProvider>(context, listen: false);
      final success = await ambigramProvider.shareAmbigram();

      if (success) {
        AnalyticsService.logAmbigramShared(
          action: 'share',
          primaryWord: ambigramProvider.text,
          secondaryWord: ambigramProvider.secondaryText,
          styleId: ambigramProvider.styleId,
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to share ambigram'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  void _createNew() {
    final ambigramProvider =
        Provider.of<AmbigramProvider>(context, listen: false);
    ambigramProvider.clearAmbigram();
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
      ),
      body: Consumer<AmbigramProvider>(
        builder: (context, ambigramProvider, _) {
          if (ambigramProvider.ambigramImageUrl == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No ambigram generated yet'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/');
                    },
                    child: const Text('Create Ambigram'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Preview image
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PreviewImage(
                    imageUrl: ambigramProvider.ambigramImageUrl!,
                    backgroundColor: ambigramProvider.backgroundColor,
                  ),
                ),
              ),

              // Action buttons
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Your Ambigram for "${ambigramProvider.text}"',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    if (ambigramProvider.secondaryText != null) ...[
                      Text(
                        '& "${ambigramProvider.secondaryText}"',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ActionButton(
                          icon: Icons.save_alt,
                          label: 'Save',
                          onPressed: _isSaving ? null : _saveAmbigram,
                          isLoading: _isSaving,
                        ),
                        ActionButton(
                          icon: Icons.share,
                          label: 'Share',
                          onPressed: _isSharing ? null : _shareAmbigram,
                          isLoading: _isSharing,
                        ),
                        ActionButton(
                          icon: Icons.refresh,
                          label: 'New',
                          onPressed: _createNew,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // App promotion text
                    const Text(
                      AppStrings.sharePromotionText,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
