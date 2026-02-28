import '../../data/models/signup_request.dart';
import '../../../../../core/constants/enum.dart';
import 'base_signup_handler.dart';

class TVStationSignupHandler extends BaseSignupHandler {
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
    final tvStationInfo = TVStationInfo(
      businessName: roleData['businessName'] ?? '',
      businessAddress: roleData['businessAddress'] ?? '',
      rcNumber: roleData['rcNumber'] ?? '',
      tinNumber: roleData['tinNumber'] ?? '',
      contactPhone: roleData['contactPhone'] ?? '',
      businessWebsite: roleData['businessWebsite'],
      broadcastType: roleData['broadcastType'] ?? '',
      channelType: roleData['channelType'] ?? '',
      operatingRegions: getGenresList(roleData['operatingRegions']),
      contentFocus: getGenresList(roleData['contentFocus']),
      yearsOfOperation: extractIntValue(roleData['yearsOfOperation']),
      averageDailyViewership: extractIntValue(roleData['averageDailyViewership']),
    );

    return SignUpRequest(
      role: UserRole.TV_STATION.value,
      authProvider: AuthProvider.INTERNAL.value,
      accountType: accountType,
      tvStationInfo: tvStationInfo,
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
