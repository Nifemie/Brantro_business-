import '../../data/models/signup_request.dart';
import '../../../../../core/constants/enum.dart';
import 'base_signup_handler.dart';

class UGCCreatorSignupHandler extends BaseSignupHandler {
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
    final ugcInfo = UGCInfo(
      displayName: roleData['displayName'] ?? '',
      contentStyle: getGenresList(roleData['contentStyle']),
      niches: getGenresList(roleData['niches']),
      contentFormats: getGenresList(roleData['contentFormats']),
      yearsOfExperience: extractIntValue(roleData['yearsOfExperience']),
      portfolioLink: roleData['portfolioLink'],
      availabilityType: roleData['availabilityType'] ?? '',
    );

    return SignUpRequest(
      role: UserRole.UGC_CREATOR.value,
      authProvider: AuthProvider.INTERNAL.value,
      accountType: accountType,
      ugcInfo: ugcInfo,
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
