import '../../data/models/signup_request.dart';
import '../../../../../core/constants/enum.dart';
import 'base_signup_handler.dart';

class CreativeSignupHandler extends BaseSignupHandler {
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
    final List<String> skills = roleData['skills'] != null
        ? (roleData['skills'] as String).split(',').map((s) => s.trim()).toList()
        : [];

    final List<String> toolsUsed = roleData['toolsUsed'] != null
        ? (roleData['toolsUsed'] as String).split(',').map((s) => s.trim()).toList()
        : [];

    final creativeInfo = CreativeInfo(
      displayName: roleData['displayName'],
      creativeType: roleData['creativeType'],
      skills: skills,
      specialization: roleData['specialization'],
      toolsUsed: toolsUsed,
      yearsOfExperience: extractIntValue(roleData['yearsOfExperience']),
      numberOfProjects: extractIntValue(roleData['numberOfProjects']),
      portfolioLink: roleData['portfolioLink'],
      availabilityType: roleData['availabilityType'],
    );

    return SignUpRequest(
      role: UserRole.DESIGNER.value,
      authProvider: AuthProvider.INTERNAL.value,
      accountType: accountType,
      creativeInfo: creativeInfo,
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
