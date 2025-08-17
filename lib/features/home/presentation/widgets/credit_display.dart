import 'package:flutter/material.dart';

/// Widget to display user credits
class CreditDisplay extends StatelessWidget {
  /// Number of credits to display
  final int credits;

  /// Default constructor
  const CreditDisplay({
    super.key,
    required this.credits,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 8),
          Text(
            'Credits: $credits',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () {
              // Show dialog explaining credits
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Credits'),
                  content: const Text(
                    'Credits are used to generate ambigrams. '
                    'You can earn more credits by watching rewarded ads '
                    'or by purchasing them.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.info_outline, size: 16),
            label: const Text('Get More'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
        ],
      ),
    );
  }
}
