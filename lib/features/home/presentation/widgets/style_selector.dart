import 'package:flutter/material.dart';
import '../../../../core/services/firebase_remote_config_stub.dart';

/// Widget for selecting ambigram style
class StyleSelector extends StatelessWidget {
  /// Currently selected style ID
  final String selectedStyleId;

  /// Callback when a style is selected
  final ValueChanged<String> onStyleSelected;

  /// Default constructor
  const StyleSelector({
    super.key,
    required this.selectedStyleId,
    required this.onStyleSelected,
  });

  @override
  Widget build(BuildContext context) {
    final styles = _getStyles();

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: styles.length,
        itemBuilder: (context, index) {
          final style = styles[index];
          final isSelected = style['id'] == selectedStyleId;

          return GestureDetector(
            onTap: () => onStyleSelected(style['id'] as String),
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade300,
                  width: isSelected ? 3 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Style icon or sample
                  Container(
                    width: 60,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        'Aa',
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontStyle: style['id'] == 'gothic'
                              ? FontStyle.italic
                              : FontStyle.normal,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Style name
                  Text(
                    style['name'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // Style description
                  Text(
                    style['description'] as String,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Get styles from remote config or use default ones
  List<Map<String, dynamic>> _getStyles() {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      final stylesJson = remoteConfig.getString('ambigram_styles');
      if (stylesJson.isNotEmpty) {
        // Parse styles from JSON if available
        // Not implemented here for simplicity
      }
    } catch (e) {
      // Ignore any remote config errors
    }

    // Default styles if remote config fails
    return [
      {
        'id': 'classic',
        'name': 'Classic',
        'description': 'Traditional ambigram style'
      },
      {
        'id': 'gothic',
        'name': 'Gothic',
        'description': 'Gothic inspired ambigram style'
      },
      {
        'id': 'modern',
        'name': 'Modern',
        'description': 'Clean modern ambigram style'
      },
    ];
  }
}
