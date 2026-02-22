import '../../data/models/signup_request.dart';
import '../../../../../core/constants/enum.dart';
import 'base_signup_handler.dart';

class DesignerSignupHandler extends BaseSignupHandler {
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
    final designerInfo = DesignerInfo(
      businessName: roleData['businessName'],
      businessAddress: roleData['businessAddress'],
      businessWebsite: roleData['businessWebsite'],
      telephoneNumber: roleData['telephoneNumber'],
      portfolioUrl: roleData['portfolioUrl'],
      bio: roleData['bio'],
      skillTags: roleData['skillTags'],
      experienceLevel: roleData['experienceLevel'],
      pricingModel: roleData['pricingModel'],
      price: double.tryParse(roleData['price']?.toString() ?? ''),
    );

    return SignUpRequest(
      role: UserRole.DESIGNER.value,
      authProvider: AuthProvider.INTERNAL.value,
      accountType: accountType,
      designerInfo: designerInfo,
      name: name,
      emailAddress: email,
      phoneNumber: phone,
      password: password,
      country: country ?? 'Nigeria',
      state: state,
      city: city,
      address: address,
      idType: idType,
      idNumber: idNumber,
      tinNumber: tinNumber,
    );
  }
}
