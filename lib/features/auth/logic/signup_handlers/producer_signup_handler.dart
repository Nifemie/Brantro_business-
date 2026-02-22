import '../../data/models/signup_request.dart';
import '../../../../../core/constants/enum.dart';
import 'base_signup_handler.dart';

class ProducerSignupHandler extends BaseSignupHandler {
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
    final contentProducerInfo = ContentProducerInfo(
      producerName: roleData['producerName'],
      businessName: roleData['businessName'],
      specialization: roleData['specialization'],
      serviceTypes: getGenresList(roleData['serviceTypes']),
      yearsOfExperience: extractIntValue(roleData['yearsOfExperience']),
      numberOfProductions: extractIntValue(roleData['numberOfProductions']),
      portfolioLink: roleData['portfolioLink'],
      availabilityType: roleData['availabilityType'],
      businessAddress: roleData['businessAddress'],
      businessWebsite: roleData['businessWebsite'],
      idType: roleData['idType'],
      idNumber: roleData['idNumber'],
      tinNumber: roleData['tinNumber'] ?? tinNumber,
    );

    return SignUpRequest(
      role: UserRole.PRODUCER.value,
      authProvider: AuthProvider.INTERNAL.value,
      accountType: accountType,
      contentProducerInfo: contentProducerInfo,
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
