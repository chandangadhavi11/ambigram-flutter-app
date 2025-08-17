import 'package:flutter/material.dart';

/// A menu item for the profile screen
class ProfileMenuItem extends StatelessWidget {
  /// Icon to display
  final IconData icon;
  
  /// Title of the menu item
  final String title;
  
  /// Optional subtitle for the menu item
  final String? subtitle;
  
  /// Callback when the menu item is tapped
  final VoidCallback? onTap;
  
  /// Whether to show a divider below this item
  final bool showDivider;
  
  /// Default constructor
  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: subtitle != null ? Text(subtitle!) : null,
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
        if (showDivider)
          const Divider(
            height: 1,
          ),
      ],
    );
  }
}
