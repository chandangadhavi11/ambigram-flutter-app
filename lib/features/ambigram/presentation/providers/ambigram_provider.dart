import 'dart:io';
import 'package:flutter/material.dart';

/// Provider for managing ambigram-related state
class AmbigramProvider extends ChangeNotifier {
  String _text = '';
  String? _secondaryText;
  String _styleId = 'classic';
  String _backgroundColor = '#FFFFFF';
  String? _ambigramImageUrl;
  File? _savedAmbigramFile;
  bool _isLoading = false;
  bool _isPreview = false;

  /// The primary text to convert to ambigram
  String get text => _text;
  
  /// The secondary text to convert to ambigram (optional)
  String? get secondaryText => _secondaryText;
  
  /// The selected style ID for the ambigram
  String get styleId => _styleId;
  
  /// The selected background color for the ambigram
  String get backgroundColor => _backgroundColor;
  
  /// The URL of the generated ambigram image
  String? get ambigramImageUrl => _ambigramImageUrl;
  
  /// The saved ambigram file
  File? get savedAmbigramFile => _savedAmbigramFile;
  
  /// Whether an ambigram is being generated
  bool get isLoading => _isLoading;
  
  /// Whether we are in preview mode
  bool get isPreview => _isPreview;

  /// Sets the primary text to convert to ambigram
  void setText(String value) {
    _text = value;
    notifyListeners();
  }
  
  /// Sets the secondary text to convert to ambigram
  void setSecondaryText(String? value) {
    _secondaryText = value;
    notifyListeners();
  }
  
  /// Sets the style ID for the ambigram
  void setStyleId(String value) {
    _styleId = value;
    notifyListeners();
  }
  
  /// Sets the background color for the ambigram
  void setBackgroundColor(String value) {
    _backgroundColor = value;
    notifyListeners();
  }

  /// Sets the ambigram image URL
  void setAmbigramImageUrl(String? url) {
    _ambigramImageUrl = url;
    notifyListeners();
  }

  /// Sets the saved ambigram file
  void setSavedAmbigramFile(File? file) {
    _savedAmbigramFile = file;
    notifyListeners();
  }

  /// Sets whether an ambigram is being generated
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Sets whether we are in preview mode
  void setPreviewMode(bool value) {
    _isPreview = value;
    notifyListeners();
  }

  /// Generates an ambigram from the given text
  Future<void> generateAmbigram() async {
    if (_text.isEmpty) return;
    
    setLoading(true);
    try {
      // TODO: Implement API call to generate ambigram
      // This is a placeholder, we'll replace with actual API call later
      await Future.delayed(const Duration(seconds: 2));
      setAmbigramImageUrl('https://example.com/ambigram.png');
    } catch (e) {
      setAmbigramImageUrl(null);
    } finally {
      setLoading(false);
    }
  }

  /// Saves the ambigram to the device
  Future<bool> saveAmbigram() async {
    try {
      // TODO: Implement saving ambigram to device
      // This is a placeholder, we'll replace with actual implementation later
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Shares the ambigram
  Future<bool> shareAmbigram() async {
    try {
      // TODO: Implement sharing ambigram
      // This is a placeholder, we'll replace with actual implementation later
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Clears the current ambigram
  void clearAmbigram() {
    _text = '';
    _secondaryText = null;
    _ambigramImageUrl = null;
    _savedAmbigramFile = null;
    _isPreview = false;
    notifyListeners();
  }
}
