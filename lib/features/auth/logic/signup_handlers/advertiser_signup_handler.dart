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

    String cleanPhone = phone.trim().replaceAll(RegExp(r'\D'), '');
    if (cleanPhone.startsWith('234')) cleanPhone = cleanPhone.substring(3);
    if (!cleanPhone.startsWith('0')) cleanPhone = '0$cleanPhone';

    String? rawTel = roleData['businessTelephoneNumber']?.toString().trim();
    String? formattedTel;
    if (rawTel != null && rawTel.isNotEmpty) {
      String cleanTel = rawTel.replaceAll(RegExp(r'\D'), '');
      if (cleanTel.startsWith('234')) cleanTel = cleanTel.substring(3);
      if (!cleanTel.startsWith('0')) cleanTel = '0$cleanTel';
      formattedTel = cleanTel;
    }

    if (accountType == 'BUSINESS') {
      advertiserInfo = AdvertiserInfo(
        businessName: roleData['businessName'],
        businessAddress: roleData['businessAddress'],
        industry: roleData['industry'],
        telephoneNumber: formattedTel ?? roleData['businessTelephoneNumber'],
        businessWebsite: roleData['businessWebsite'],
        idType: idType ?? (roleData['businessRegistrationNumber'] != null ? 'CAC' : null),
        idNumber: roleData['businessRegistrationNumber'] ?? idNumber,
        tinNumber: roleData['tinNumber'] ?? tinNumber,
      );
    }

    return SignUpRequest(
      role: UserRole.ADVERTISER.value,
      authProvider: AuthProvider.INTERNAL.value,
      accountType: accountType,
      advertiserInfo: advertiserInfo,
      name: name,
      emailAddress: email,
      phoneNumber: cleanPhone,
      password: password,
      country: country ?? 'Nigeria',
      state: state,
      city: city,
      address: address,
    );
  }
}
