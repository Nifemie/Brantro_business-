import '../../data/models/signup_request.dart';
import '../../../../../core/constants/enum.dart';
import 'base_signup_handler.dart';

class ScreenBillboardSignupHandler extends BaseSignupHandler {
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
    final screenBillboardInfo = ScreenBillboardInfo(
      businessName: roleData['businessName'] ?? '',
      permitNumber: roleData['permitNumber'] ?? '',
      industry: roleData['industry'] ?? '',
      operatingStates: getGenresList(roleData['operatingStates']),
      yearsOfOperation: roleData['yearsOfOperation'],
      businessWebsite: roleData['businessWebsite'],
      businessAddress: roleData['businessAddress'] ?? '',
      idType: roleData['idType'] ?? 'CAC',
      idRcNumber: roleData['idRcNumber'] ?? '',
      tinNumber: roleData['tinNumber'] ?? '',
    );

    return SignUpRequest(
      role: UserRole.SCREEN_BILLBOARD.value,
      authProvider: AuthProvider.INTERNAL.value,
      accountType: accountType,
      screenBillboardInfo: screenBillboardInfo,
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
