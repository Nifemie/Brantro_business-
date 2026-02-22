import '../../data/models/signup_request.dart';
import '../../../../../core/constants/enum.dart';
import 'base_signup_handler.dart';

class InfluencerSignupHandler extends BaseSignupHandler {
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
    final influencerInfo = InfluencerInfo(
      displayName: roleData['displayName'],
      primaryPlatform: roleData['primaryPlatform'],
      contentCategory: roleData['contentCategory'],
      niche: roleData['niche'],
      audienceSizeRange: roleData['audienceSizeRange'],
      averageEngagementRate: double.tryParse(
        roleData['averageEngagementRate']?.toString() ?? '',
      ),
      contentFormats: getGenresList(roleData['contentFormats']),
      portfolioLink: roleData['portfolioLink'],
      availabilityType: roleData['availabilityType'] ?? '',
    );

    return SignUpRequest(
      role: UserRole.INFLUENCER.value,
      authProvider: AuthProvider.INTERNAL.value,
      accountType: accountType,
      influencerInfo: influencerInfo,
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
