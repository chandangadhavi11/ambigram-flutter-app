import 'package:flutter/material.dart';

/// A button with an icon and label for actions in the preview screen
class ActionButton extends StatelessWidget {
  /// Icon to display
  final IconData icon;

  /// Text label for the button
  final String label;

  /// Callback when the button is pressed
  final VoidCallback? onPressed;

  /// Whether the button is in a loading state
  final bool isLoading;

  /// Default constructor
  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            tooltip: label,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
