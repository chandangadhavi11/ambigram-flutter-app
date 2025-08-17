import 'package:flutter/material.dart';
import '../../../../core/services/firebase_remote_config_stub.dart';

/// Widget for selecting background color for ambigrams
class BackgroundColorPicker extends StatelessWidget {
  /// Currently selected color (hex format)
  final String selectedColor;
  
  /// Callback when a color is selected
  final ValueChanged<String> onColorSelected;

  /// Default constructor
  const BackgroundColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _getColors().map((colorHex) {
          final color = _hexToColor(colorHex);
          final isSelected = colorHex == selectedColor;
          
          return GestureDetector(
            onTap: () => onColorSelected(colorHex),
            child: Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected 
                      ? Theme.of(context).colorScheme.primary 
                      : Colors.grey.shade300,
                  width: isSelected ? 3 : 1,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Icon(
                        Icons.check,
                        color: _isDarkColor(color) ? Colors.white : Colors.black,
                      ),
                    )
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Get colors from remote config or use default ones
  List<String> _getColors() {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      final colorsJson = remoteConfig.getString('background_colors');
      if (colorsJson.isNotEmpty) {
        // Parse colors from JSON if available
        // Not implemented here for simplicity
      }
    } catch (e) {
      // Ignore any remote config errors
    }
    
    // Default colors if remote config fails
    return [
      '#FFFFFF', // White
      '#F5F5F5', // Off-white
      '#EEEEEE', // Light grey
      '#E0F7FA', // Light cyan
      '#F3E5F5', // Light purple
      '#FFF3E0', // Light orange
      '#FFEBEE', // Light red
    ];
  }

  /// Convert hex color string to Color object
  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
  
  /// Check if a color is dark (for contrast text)
  bool _isDarkColor(Color color) {
    return (color.red * 0.299 + color.green * 0.587 + color.blue * 0.114) < 128;
  }
}
