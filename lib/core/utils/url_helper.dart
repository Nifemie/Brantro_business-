import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Helper class for opening URLs in external applications
class UrlHelper {
  /// Opens a URL in the device's default external browser
  /// 
  /// Shows appropriate user feedback via SnackBar if:
  /// - The URL is null or empty
  /// - The URL cannot be opened
  /// - An error occurs during the process
  /// 
  /// Parameters:
  /// - [context]: BuildContext for showing SnackBar messages
  /// - [url]: The URL string to open
  /// - [errorMessage]: Optional custom error message when URL is unavailable
  static Future<void> openUrl(
    BuildContext context,
    String? url, {
    String errorMessage = 'No link available',
  }) async {
    if (url == null || url.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
      return;
    }

    // Ensure URL has a proper scheme
    String urlWithScheme = url;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      urlWithScheme = 'https://$url';
    }

    final uri = Uri.tryParse(urlWithScheme);
    if (uri == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid URL format')),
        );
      }
      return;
    }

    try {
      final canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        // Use platformDefault mode for better compatibility
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cannot open link')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening link: $e')),
        );
      }
    }
  }

  /// Opens a portfolio link with a specific error message
  static Future<void> openPortfolioLink(
    BuildContext context,
    String? portfolioUrl,
  ) async {
    await openUrl(
      context,
      portfolioUrl,
      errorMessage: 'No portfolio link available',
    );
  }
}
