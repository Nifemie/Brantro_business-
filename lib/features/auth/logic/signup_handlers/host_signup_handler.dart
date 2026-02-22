import '../../data/models/signup_request.dart';
import '../../../../../core/constants/enum.dart';
import 'base_signup_handler.dart';

class HostSignupHandler extends BaseSignupHandler {
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
    final hostInfo = HostInfo(
      businessName: roleData['businessName'],
      permitNumber: roleData['permitNumber'],
      businessAddress: roleData['businessAddress'],
      businessWebsite: roleData['businessWebsite'],
      industry: roleData['industry'],
      operatingCities: getGenresList(roleData['operatingCities']),
      yearsOfOperation: extractIntValue(roleData['yearsOfOperation']),
      idType: roleData['idType'],
      idNumber: roleData['idNumber'],
      tinNumber: roleData['tinNumber'],
    );

    return SignUpRequest(
      role: UserRole.HOST.value,
      authProvider: AuthProvider.INTERNAL.value,
      accountType: accountType,
      hostInfo: hostInfo,
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
