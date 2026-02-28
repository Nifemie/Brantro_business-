import '../../data/models/signup_request.dart';
import '../../../../../core/constants/enum.dart';
import 'base_signup_handler.dart';

class MediaHouseSignupHandler extends BaseSignupHandler {
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
    final mediaHouseInfo = MediaHouseInfo(
      businessName: roleData['businessName'] ?? '',
      businessAddress: roleData['businessAddress'] ?? '',
      rcNumber: roleData['rcNumber'] ?? '',
      tinNumber: roleData['tinNumber'] ?? '',
      contactPhone: roleData['contactPhone'] ?? '',
      businessWebsite: roleData['businessWebsite'],
      mediaTypes: getGenresList(roleData['mediaTypes']),
      operatingRegions: getGenresList(roleData['operatingRegions']),
      yearsOfOperation: extractIntValue(roleData['yearsOfOperation']),
      contentFocus: getGenresList(roleData['contentFocus']),
      estimatedMonthlyReach: extractIntValue(roleData['estimatedMonthlyReach']),
    );

    return SignUpRequest(
      role: UserRole.MEDIA_HOUSE.value,
      authProvider: AuthProvider.INTERNAL.value,
      accountType: accountType,
      mediaHouseInfo: mediaHouseInfo,
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
