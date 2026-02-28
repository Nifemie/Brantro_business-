import '../../data/models/signup_request.dart';
import '../../../../../core/constants/enum.dart';
import 'base_signup_handler.dart';

class RadioStationSignupHandler extends BaseSignupHandler {
  @override
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
  }) async {
    final radioStationInfo = RadioStationInfo(
      businessName: roleData['businessName'] ?? '',
      businessAddress: roleData['businessAddress'] ?? '',
      rcNumber: roleData['rcNumber'] ?? '',
      tinNumber: roleData['tinNumber'] ?? '',
      contactPhone: roleData['contactPhone'] ?? '',
      businessWebsite: roleData['businessWebsite'],
      broadcastBand: roleData['broadcastBand'] ?? '',
      primaryLanguage: roleData['primaryLanguage'] ?? '',
      operatingRegions: getGenresList(roleData['operatingRegions']),
      contentFocus: getGenresList(roleData['contentFocus']),
      yearsOfOperation: extractIntValue(roleData['yearsOfOperation']),
      averageDailyListenership: extractIntValue(roleData['averageDailyListenership']),
    );

    return SignUpRequest(
      role: UserRole.RADIO_STATION.value,
      authProvider: AuthProvider.INTERNAL.value,
      accountType: accountType,
      radioStationInfo: radioStationInfo,
      name: name,
      emailAddress: email,
      phoneNumber: phone,
      password: password,
      country: country ?? 'Nigeria',
      state: state,
      city: city,
      address: address,
    );
  }
}
