import '../../data/models/signup_request.dart';
import '../../../../../core/constants/enum.dart';
import 'base_signup_handler.dart';

class TalentManagerSignupHandler extends BaseSignupHandler {
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
    final talentManagerInfo = TalentManagerInfo(
      managerDisplayName: roleData['managerDisplayName'],
      businessName: roleData['businessName'],
      businessAddress: roleData['businessAddress'],
      businessTelephoneNumber: roleData['businessTelephoneNumber'],
      numberOfTalentsManaged: roleData['numberOfTalentsManaged'],
      talentCategories: getGenresList(roleData['talentCategories']),
      yearsOfExperience: roleData['yearsOfExperience'],
      website: roleData['website'],
      businessRegistrationNumber: roleData['businessRegistrationNumber'],
      tinNumber: roleData['tinNumber'] ?? tinNumber,
    );

    return SignUpRequest(
      role: UserRole.TALENT_MANAGER.value,
      authProvider: AuthProvider.INTERNAL.value,
      accountType: accountType,
      talentManagerInfo: talentManagerInfo,
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
