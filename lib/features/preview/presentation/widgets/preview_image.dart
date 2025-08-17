import 'package:flutter/material.dart';

/// Widget to display the preview of an ambigram image
class PreviewImage extends StatelessWidget {
  /// URL of the image to display
  final String imageUrl;

  /// Background color of the image (hex format)
  final String backgroundColor;

  /// Default constructor
  const PreviewImage({
    super.key,
    required this.imageUrl,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _hexToColor(backgroundColor),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: imageUrl.startsWith('data:')
            ? _buildSvgImage()
            : Image.network(
                imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                  );
                },
              ),
      ),
    );
  }

  /// Build SVG image from data URL
  Widget _buildSvgImage() {
    // In a real implementation, use flutter_svg to render the SVG
    return const Center(
      child: Text('SVG Preview'),
    );
  }

  /// Convert hex color string to Color object
  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
