import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// A [TextInputFormatter] that formats numeric inputs with comma thousands separators in real-time.
/// Supports integers and decimal values with up to 2 decimal places (standard currency/amount format).
/// Preserves cursor position intelligently during user typing or deletion.
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final int maxDecimalDigits;

  ThousandsSeparatorInputFormatter({this.maxDecimalDigits = 2});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Only allow digits, comma, and at most one period
    String cleanText = newValue.text.replaceAll(',', '').trim();
    if (!RegExp(r'^\d*\.?\d*$').hasMatch(cleanText)) {
      return oldValue;
    }

    // Split into integer part and decimal part
    final parts = cleanText.split('.');
    String integerPart = parts[0];
    String? decimalPart = parts.length > 1 ? parts[1] : null;

    if (decimalPart != null && decimalPart.length > maxDecimalDigits) {
      decimalPart = decimalPart.substring(0, maxDecimalDigits);
    }

    // Format integer part with commas
    String formattedInteger = '';
    if (integerPart.isNotEmpty) {
      // Remove any leading zeros unless it's just '0'
      if (integerPart.length > 1 && integerPart.startsWith('0')) {
        integerPart = int.tryParse(integerPart)?.toString() ?? integerPart;
      }
      formattedInteger = NumberFormat('#,###').format(int.tryParse(integerPart) ?? 0);
    }

    String formattedText = formattedInteger;
    if (parts.length > 1) {
      formattedText += '.$decimalPart';
    }

    // Calculate cursor position
    int cursorPosition = newValue.selection.end;
    // Count how many non-comma characters appeared before the old cursor position
    int charsBeforeCursor = 0;
    for (int i = 0; i < cursorPosition && i < newValue.text.length; i++) {
      if (newValue.text[i] != ',') {
        charsBeforeCursor++;
      }
    }

    // Find the new cursor position in the formatted string matching that character count
    int newCursorOffset = 0;
    int matchedChars = 0;
    while (newCursorOffset < formattedText.length && matchedChars < charsBeforeCursor) {
      if (formattedText[newCursorOffset] != ',') {
        matchedChars++;
      }
      newCursorOffset++;
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: newCursorOffset),
    );
  }

  /// Strips all commas and surrounding whitespace from a formatted amount string.
  static String clean(String? text) {
    if (text == null) return '';
    return text.replaceAll(',', '').trim();
  }

  /// Safely parses a comma-separated formatted string into a [double].
  static double? tryParseDouble(String? text) {
    if (text == null) return null;
    final cleaned = clean(text);
    return double.tryParse(cleaned);
  }

  /// Safely parses a comma-separated formatted string into an [int].
  static int? tryParseInt(String? text) {
    if (text == null) return null;
    final cleaned = clean(text);
    // If it contains a decimal point, parse as double first then round or truncate
    if (cleaned.contains('.')) {
      final d = double.tryParse(cleaned);
      return d?.toInt();
    }
    return int.tryParse(cleaned);
  }

  /// Formats a [num] into a comma thousands string representation.
  static String format(num? value) {
    if (value == null) return '';
    if (value % 1 == 0) {
      return NumberFormat('#,###').format(value);
    }
    return NumberFormat('#,###.##').format(value);
  }
}
