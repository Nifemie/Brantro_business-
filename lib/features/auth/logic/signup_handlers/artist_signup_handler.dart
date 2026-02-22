import '../../data/models/signup_request.dart';
import '../../../../../core/constants/enum.dart';
import 'base_signup_handler.dart';

class ArtistSignupHandler extends BaseSignupHandler {
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
    final artistInfo = ArtistInfo(
      stageName: roleData['stageName'] ?? '',
      primaryProfession: roleData['profession'] ?? '',
      specialization: roleData['specialization'] ?? '',
      genres: getGenresList(roleData['genre']),
      yearsOfExperience: extractIntValue(roleData['yearsOfExperience']),
      numberOfProductions: extractIntValue(roleData['numberOfProductions']),
      availabilityType: roleData['availabilityType'] ?? '',
      portfolioLink: roleData['portfolioLink'],
      managementType: roleData['whoManagesYou'] ?? 'SELF',
    );

    return SignUpRequest(
      role: UserRole.ARTIST.value,
      authProvider: AuthProvider.INTERNAL.value,
      accountType: accountType,
      artistInfo: artistInfo,
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
