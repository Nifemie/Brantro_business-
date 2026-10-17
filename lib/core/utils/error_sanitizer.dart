/// Utility to sanitize backend error messages for display to users.
///
/// Fixes BRT-032:
/// - Strips backend brackets and code prefixes (e.g. `[role is not allowed: ...]`).
/// - Replaces raw internal roles like `SUPER_ADMIN` and `ADMIN` with user-friendly text.
/// - Returns clean, professional copy.
class ErrorSanitizer {
  ErrorSanitizer._();

  static String sanitize(dynamic rawError) {
    if (rawError == null) return 'An unexpected error occurred. Please try again.';

    String message = rawError.toString().trim();

    // Remove Exception: prefix if present
    if (message.startsWith('Exception:')) {
      message = message.substring('Exception:'.length).trim();
    }

    // Strip outer or nested brackets: [ ... ]
    while (message.startsWith('[') && message.endsWith(']')) {
      message = message.substring(1, message.length - 1).trim();
    }
    // Also remove bracket blocks like "[role must be one of...]"
    message = message.replaceAll(RegExp(r'\[|\]'), '');

    // Prevent exposing internal privileged roles (BRT-032)
    message = message.replaceAll('SUPER_ADMIN', 'Service Provider');
    message = message.replaceAll('ADMIN', 'Service Provider');

    // Make common technical messages friendly
    if (message.toLowerCase().contains('role is not allowed') ||
        message.toLowerCase().contains('role must be one of')) {
      return 'The selected role is currently not eligible for registration in this app. Please choose a valid seller or service provider role.';
    }

    if (message.toLowerCase().contains('user with this email') ||
        (message.toLowerCase().contains('email') && message.toLowerCase().contains('already exist'))) {
      return 'An account with this email address already exists. Please use a different email or sign in.';
    }

    if (message.toLowerCase().contains('user with this phone') ||
        (message.toLowerCase().contains('phone') && message.toLowerCase().contains('already exist'))) {
      return 'An account with this phone number already exists. Please use a different phone number or sign in.';
    }

    if (message.toLowerCase().contains('user already exists') ||
        message.toLowerCase().contains('already exists') ||
        message.toLowerCase().contains('already exist') ||
        message.toLowerCase().contains('duplicate key')) {
      return 'An account with this email or phone number already exists. Please sign in instead.';
    }

    if (message.toLowerCase().contains('invalid credentials') ||
        message.toLowerCase().contains('unauthorized') ||
        message.toLowerCase().contains('wrong password')) {
      return 'Invalid email or password. Please check your details and try again.';
    }

    if (message.toLowerCase().contains('socketexception') ||
        message.toLowerCase().contains('connection refused') ||
        message.toLowerCase().contains('network') ||
        message.toLowerCase().contains('timed out')) {
      return 'Network connection error. Please check your internet connection and try again.';
    }

    // Ensure capitalized first letter and trailing period
    if (message.isNotEmpty) {
      message = message[0].toUpperCase() + message.substring(1);
      if (!message.endsWith('.') && !message.endsWith('!')) {
        message = '$message.';
      }
    }

    return message;
  }
}
