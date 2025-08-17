import 'package:flutter/material.dart';
import '../../../../core/services/analytics_service.dart';
import '../widgets/ambigram_preview.dart';

/// Demo screen for the AmbigramPreview widget
class AmbigramPreviewDemo extends StatefulWidget {
  /// Default constructor
  const AmbigramPreviewDemo({super.key});

  @override
  State<AmbigramPreviewDemo> createState() => _AmbigramPreviewDemoState();
}

class _AmbigramPreviewDemoState extends State<AmbigramPreviewDemo> {
  String _firstWord = 'ambigram';
  String _secondWord = '';
  int _styleIndex = 0;
  String _backgroundColor = '#FFFFFF';
  bool _highlightBackground = false;
  
  final List<String> _availableStyles = [
    'Classic',
    'Modern',
    'Bold',
    'Elegant',
    'Graffiti'
  ];

  final List<Color> _colorOptions = [
    Colors.white,
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
  ];

  @override
  void initState() {
    super.initState();
    AnalyticsService.logScreenView(screenName: 'ambigram_preview_demo');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambigram Preview Demo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Preview area
            Container(
              height: 200,
              padding: const EdgeInsets.all(8.0),
              child: AmbigramPreview(
                firstWord: _firstWord,
                secondWord: _secondWord,
                chipIndex: _styleIndex,
                backgroundColor: _backgroundColor,
                highlightBackground: _highlightBackground,
              ),
            ),
            const SizedBox(height: 24),
            
            // Controls
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Controls',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(),
                    
                    // First word input
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'First Word',
                        hintText: 'Enter the first word',
                      ),
                      initialValue: _firstWord,
                      onChanged: (value) {
                        setState(() {
                          _firstWord = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Second word input
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Second Word (Optional)',
                        hintText: 'Enter the second word',
                      ),
                      initialValue: _secondWord,
                      onChanged: (value) {
                        setState(() {
                          _secondWord = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // Style selection
                    Text(
                      'Style',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: List.generate(_availableStyles.length, (index) {
                        return ChoiceChip(
                          label: Text(_availableStyles[index]),
                          selected: _styleIndex == index,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _styleIndex = index;
                              });
                            }
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    
                    // Background color selection
                    Text(
                      'Background Color',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _colorOptions.map((color) {
                        final colorHex = '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _backgroundColor = colorHex;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color,
                              border: Border.all(
                                color: _backgroundColor == colorHex
                                    ? Colors.blue
                                    : Colors.grey,
                                width: _backgroundColor == colorHex ? 3 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    
                    // Highlight background option
                    SwitchListTile(
                      title: const Text('Highlight Background'),
                      value: _highlightBackground,
                      onChanged: (value) {
                        setState(() {
                          _highlightBackground = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            const Text(
              'Tap the preview to rotate the ambigram.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
