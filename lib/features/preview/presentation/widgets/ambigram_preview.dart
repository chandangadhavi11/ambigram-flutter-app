import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import '../../../../core/network/network_info.dart';
import '../../../../core/services/firebase_remote_config_stub.dart';

/// Widget to display an ambigram preview that can be rotated
class AmbigramPreview extends StatefulWidget {
  /// The first word to display
  final String firstWord;

  /// The optional second word to display
  final String? secondWord;

  /// The style index (chip index) for the ambigram
  final int chipIndex;

  /// The background color for the ambigram
  final String backgroundColor;

  /// Whether to highlight the background
  final bool highlightBackground;

  /// Creates a new [AmbigramPreview]
  const AmbigramPreview({
    Key? key,
    required this.firstWord,
    this.secondWord,
    required this.chipIndex,
    required this.backgroundColor,
    this.highlightBackground = false,
  }) : super(key: key);

  @override
  State<AmbigramPreview> createState() => _AmbigramPreviewState();
}

class _AmbigramPreviewState extends State<AmbigramPreview> {
  String _svgBaseUrl = '';
  bool _hasInternet = true;
  double _rotationAngle = 0;
  Future<List<Uint8List?>>? _imagesFuture;
  final NetworkInfo _networkInfo = NetworkInfoImpl(Connectivity());
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  Timer? _remoteConfigRefreshTimer;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void didUpdateWidget(AmbigramPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Check if any of the key properties have changed
    if (widget.firstWord != oldWidget.firstWord ||
        widget.secondWord != oldWidget.secondWord ||
        widget.chipIndex != oldWidget.chipIndex) {
      // Cancel any ongoing fetches and refresh the images
      _refreshImages();
    }
  }

  Future<void> _initialize() async {
    // Initialize Remote Config
    await _initializeRemoteConfig();
    
    // Listen for connectivity changes
    _connectivitySubscription = _networkInfo.onConnectivityChanged.listen((result) {
      final hasInternet = result != ConnectivityResult.none;
      if (_hasInternet != hasInternet) {
        setState(() {
          _hasInternet = hasInternet;
        });
        
        if (hasInternet) {
          // Connectivity restored, refresh images
          _refreshImages();
        }
      }
    });
    
    // Check initial connectivity
    _hasInternet = await _networkInfo.isConnected;
    
    // Set up a timer to periodically refresh the remote config
    _remoteConfigRefreshTimer = Timer.periodic(const Duration(minutes: 30), (timer) {
      _initializeRemoteConfig();
    });
    
    // Initial image fetch
    _refreshImages();
  }

  Future<void> _initializeRemoteConfig() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      // Set default value for SVG base URL
      await remoteConfig.setDefaults({
        'svg_base_url': 'https://api.ambigram-generator.com/assets/styles/',
      });
      
      await remoteConfig.fetchAndActivate();
      final newBaseUrl = remoteConfig.getString('svg_base_url');
      
      if (_svgBaseUrl != newBaseUrl) {
        // If the base URL changed, update it and refresh images
        setState(() {
          _svgBaseUrl = newBaseUrl;
        });
        _refreshImages();
      }
    } catch (e) {
      debugPrint('Error initializing remote config: $e');
      // Use default value if remote config fails
      setState(() {
        _svgBaseUrl = 'https://api.ambigram-generator.com/assets/styles/';
      });
    }
  }

  void _refreshImages() {
    if (!_hasInternet) {
      setState(() {
        _imagesFuture = null;
      });
      return;
    }
    
    setState(() {
      _imagesFuture = _fetchSvgImages();
    });
  }

  Future<List<Uint8List?>> _fetchSvgImages() async {
    if (widget.firstWord.isEmpty || _svgBaseUrl.isEmpty) {
      return [];
    }
    
    try {
      final firstWord = widget.firstWord.toLowerCase();
      final secondWord = widget.secondWord != null && widget.secondWord!.isNotEmpty
          ? widget.secondWord!.toLowerCase()
          : firstWord;
      
      // Create a list of futures for parallel execution
      final futures = <Future<Uint8List?>>[];
      
      for (int i = 0; i < firstWord.length; i++) {
        // Get the current character from the first word
        final f = firstWord[i];
        
        // Get the corresponding character from the second word
        final s = secondWord.length > i 
            ? secondWord[secondWord.length - 1 - i] 
            : firstWord[firstWord.length - 1 - i];
        
        // Determine the lexicographically ordered pair
        final pair = f.compareTo(s) > 0 ? '$s$f' : '$f$s';
        
        // Build the URL for this letter pair
        final url = '$_svgBaseUrl${widget.chipIndex}/$pair.svg';
        
        // Add this request to the list of futures
        futures.add(_fetchSvg(url, isFlipped: f.compareTo(s) > 0));
      }
      
      // Execute all futures in parallel
      return await Future.wait(futures);
      
    } catch (e) {
      debugPrint('Error fetching SVG images: $e');
      return List<Uint8List?>.filled(widget.firstWord.length, null);
    }
  }

  Future<Uint8List?> _fetchSvg(String url, {bool isFlipped = false}) async {
    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        debugPrint('Failed to load SVG: ${response.statusCode}');
        return null;
      }
    } on Exception catch (e) {
      debugPrint('Error fetching SVG: $e');
      return null;
    }
  }

  void _rotatePreview() {
    setState(() {
      _rotationAngle = _rotationAngle + pi;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _remoteConfigRefreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _rotatePreview,
      child: Container(
        decoration: BoxDecoration(
          color: _hexToColor(widget.backgroundColor),
          borderRadius: BorderRadius.circular(16),
          border: widget.highlightBackground
              ? Border.all(color: Colors.blue, width: 2)
              : null,
        ),
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<Uint8List?>>(
          future: _imagesFuture,
          builder: (context, snapshot) {
            if (!_hasInternet) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'PLEASE CONNECT TO INTERNET',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            
            if (snapshot.connectionState == ConnectionState.waiting || 
                _imagesFuture == null) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'LOADING…',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            }
            
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'ERROR LOADING PREVIEW\n${snapshot.error}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'NO PREVIEW AVAILABLE',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            
            return AnimatedRotation(
              turns: _rotationAngle / (2 * pi),
              duration: const Duration(milliseconds: 500),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: snapshot.data!.map((svgBytes) {
                    if (svgBytes == null) {
                      // Error placeholder for failed SVG
                      return Container(
                        width: 50,
                        height: 50,
                        color: Colors.red.withOpacity(0.3),
                        child: const Center(
                          child: Icon(Icons.error_outline, color: Colors.red),
                        ),
                      );
                    } else {
                      // SVG image
                      return SizedBox(
                        width: 50,
                        height: 50,
                        child: SvgPicture.memory(
                          svgBytes,
                          fit: BoxFit.contain,
                        ),
                      );
                    }
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
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
