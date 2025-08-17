/// Input validators for the application.
///
/// This file provides validation functions for different types of user input.
/// Each validator returns null if the input is valid, or an error message if it's not.

/// A utility class that holds validation methods for the app.
class Validators {
  /// Private constructor to prevent instantiation
  const Validators._();

  /// Validates an email address
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    // Simple regex for email validation
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  /// Validates a password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  /// Validates that two passwords match
  static String? validatePasswordMatch(
      String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }

    if (password != confirmPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validates a name
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }

    return null;
  }

  /// Validates a primary word for ambigram generation
  static String? validatePrimaryWord(String? value) {
    if (value == null || value.isEmpty) {
      return 'Word is required';
    }

    if (value.length < 2 || value.length > 12) {
      return 'Word must be between 2 and 12 letters';
    }

    // Check if the word contains only alphabet characters
    final alphabetOnly = RegExp(r'^[a-zA-Z]+$');
    if (!alphabetOnly.hasMatch(value)) {
      return 'Only alphabet characters are allowed';
    }

    return null;
  }

  /// Validates a secondary word for ambigram generation
  static String? validateSecondaryWord(
      String? primaryWord, String? secondaryWord) {
    // Secondary word is optional
    if (secondaryWord == null || secondaryWord.isEmpty) {
      return null;
    }

    // Check if the word contains only alphabet characters
    final alphabetOnly = RegExp(r'^[a-zA-Z]+$');
    if (!alphabetOnly.hasMatch(secondaryWord)) {
      return 'Only alphabet characters are allowed';
    }

    // If primary word is provided, check that lengths match
    if (primaryWord != null &&
        primaryWord.isNotEmpty &&
        primaryWord.length != secondaryWord.length) {
      return 'Both words must be the same length';
    }

    return null;
  }

  /// Validates a credit card number
  static String? validateCreditCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Card number is required';
    }

    // Remove spaces and dashes
    final cardNumber = value.replaceAll(RegExp(r'[\s-]'), '');

    // Check if the card number contains only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(cardNumber)) {
      return 'Card number can only contain digits';
    }

    // Check length (most cards are between 13-19 digits)
    if (cardNumber.length < 13 || cardNumber.length > 19) {
      return 'Card number is invalid';
    }

    // Validate using Luhn algorithm (mod 10)
    int sum = 0;
    bool alternate = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    if (sum % 10 != 0) {
      return 'Card number is invalid';
    }

    return null;
  }

  /// Validates a credit card expiry date
  static String? validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required';
    }

    // Check format (MM/YY)
    if (!RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2})$').hasMatch(value)) {
      return 'Expiry date must be in MM/YY format';
    }

    final parts = value.split('/');
    final month = int.parse(parts[0]);
    final year = int.parse('20${parts[1]}');

    // Create date for end of the month
    final expiryDate = DateTime(year, month + 1, 0);
    final now = DateTime.now();

    if (expiryDate.isBefore(now)) {
      return 'Card has expired';
    }

    return null;
  }

  /// Validates a credit card CVV
  static String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }

    // Check if the CVV contains only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'CVV can only contain digits';
    }

    // Check length (3-4 digits)
    if (value.length < 3 || value.length > 4) {
      return 'CVV must be 3 or 4 digits';
    }

    return null;
  }
}
