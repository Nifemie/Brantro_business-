import '../../data/models/signup_request.dart';
import '../../../../../core/constants/enum.dart';
import 'base_signup_handler.dart';

class AdvertiserSignupHandler extends BaseSignupHandler {
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
    AdvertiserInfo? advertiserInfo;

    if (accountType == 'BUSINESS') {
      advertiserInfo = AdvertiserInfo(
        businessName: roleData['businessName'],
        businessAddress: roleData['businessAddress'],
        industry: roleData['industry'],
        telephoneNumber: roleData['businessTelephoneNumber'],
        businessWebsite: roleData['businessWebsite'],
        idType: idType ?? (roleData['businessRegistrationNumber'] != null ? 'CAC' : null),
        idNumber: roleData['businessRegistrationNumber'] ?? idNumber,
        tinNumber: roleData['tinNumber'] ?? tinNumber,
      );
    }

    return SignUpRequest(
      role: 'USER',
      authProvider: AuthProvider.INTERNAL.value,
      accountType: accountType,
      advertiserInfo: advertiserInfo,
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
