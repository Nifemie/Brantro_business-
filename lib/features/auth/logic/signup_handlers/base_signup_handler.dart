import '../../data/models/signup_request.dart';
import '../auth_notifiers.dart';

/// Base class for all signup handlers
abstract class BaseSignupHandler {
  /// Extracts integer value from dynamic input (handles strings like "1-3 years")
  int extractIntValue(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;

    String strValue = value.toString();
    int? parsed = int.tryParse(strValue);
    if (parsed != null) return parsed;

    RegExp regExp = RegExp(r'\d+');
    var match = regExp.firstMatch(strValue);
    if (match != null) {
      return int.tryParse(match.group(0)!) ?? 0;
    }

    return 0;
  }

  /// Converts dynamic genre data to list of strings
  List<String> getGenresList(dynamic genreData) {
    if (genreData == null) return [];
    if (genreData is List) {
      return genreData.map((e) => e.toString()).toList();
    }
    if (genreData is String) {
      return [genreData];
    }
    return [];
  }

  /// Creates the signup request for the specific role
  Future<SignUpRequest> createSignupRequest({
    required Map<String, dynamic> roleData,
    required String name,
    required String email,
    required String phone,
    required String password,
    required String? country,
    required String? state,
    required String? city,
    required String? address,
    required String accountType,
    String? idType,
    String? idNumber,
    String? tinNumber,
  });
}
