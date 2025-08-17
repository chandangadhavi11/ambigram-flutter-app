/// String constants for the application.
///
/// This file defines all the string literals used throughout the application.
/// Centralizing strings helps with localization and ensures consistency.

/// A utility class that holds all the string constants for the app.
class AppStrings {
  /// Private constructor to prevent instantiation
  const AppStrings._();
  
  // App general
  static const String appName = 'Ambigram Generator';
  static const String appTagline = 'Create beautiful mirror-symmetric word designs';
  
  // Auth screen
  static const String login = 'Login';
  static const String register = 'Register';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String continueAsGuest = 'Continue as Guest';
  static const String invalidEmail = 'Please enter a valid email';
  static const String passwordTooShort = 'Password must be at least 6 characters';
  
  // Splash screen
  static const String loading = 'Loading...';
  static const String updateRequired = 'Update Required';
  static const String updateMessage = 'Please update to the latest version to continue using the app';
  static const String update = 'Update';
  
  // Home screen
  static const String createAmbigram = 'Create Ambigram';
  static const String word = 'Word';
  static const String secondWord = 'Second Word (Optional)';
  static const String selectStyle = 'Select Style';
  static const String selectBackground = 'Select Background';
  static const String generate = 'Generate';
  static const String creditsLeft = 'Credits: ';
  static const String wordRequiredError = 'Please enter a word (2-12 letters)';
  static const String wordLengthError = 'Word must be between 2 and 12 letters';
  static const String wordMatchLengthError = 'Both words must be the same length';
  static const String alphabetOnlyError = 'Only alphabet characters are allowed';
  
  // Preview screen
  static const String preview = 'Preview';
  static const String download = 'Download';
  static const String save = 'Save to Gallery';
  static const String share = 'Share';
  static const String saveSuccess = 'Saved to gallery successfully';
  static const String saveError = 'Error saving image';
  static const String shareText = 'Check out this cool ambigram I made with the Ambigram Generator app!';
  static const String sharePromotionText = 'Created with Ambigram Generator app';
  
  // Credits
  static const String outOfCredits = 'Out of Credits';
  static const String watchAdForCredits = 'Watch Ad for 5 Credits';
  static const String buyUnlimitedCredits = 'Buy Unlimited Credits';
  static const String unlimitedCredits = 'Unlimited Credits';
  
  // Profile
  static const String profile = 'Profile';
  static const String greeting = 'Hello, ';
  static const String guest = 'Guest';
  static const String logout = 'Logout';
  static const String settings = 'Settings';
  
  // Notifications
  static const String notificationTitle = 'Time for Creativity!';
  static const String notificationBody = 'Create a new ambigram today and share with your friends!';
  
  // Errors
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError = 'Network error. Please check your connection.';
  static const String timeoutError = 'Request timed out. Please try again.';
  
  // Ads
  static const String adLoading = 'Loading Ad...';
  static const String adError = 'Failed to load ad';
  
  // Misc
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String ok = 'OK';
}
