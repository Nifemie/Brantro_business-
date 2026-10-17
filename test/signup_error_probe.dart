import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.syroltech.com/brantro/',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Test with empty string for portfolioLink
  final payload = {
    'role': 'ARTIST',
    'authProvider': 'INTERNAL',
    'name': 'Test Empty Portfolio',
    'emailAddress': 'test_port_${DateTime.now().millisecondsSinceEpoch}@gmail.com',
    'phoneNumber': '0812345${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
    'password': 'Password123@#',
    'country': 'Nigeria',
    'state': 'Lagos',
    'city': 'Ikeja',
    'address': '123 Test St',
    'artistInfo': {
      'stageName': 'Test',
      'primaryProfession': 'Musician',
      'specialization': 'Music Performance',
      'genres': ['Afrobeats'],
      'yearsOfExperience': 3,
      'numberOfProductions': 2,
      'availabilityType': 'Full Time',
      'managementType': 'SELF',
      'portfolioLink': '', // EMPTY STRING!
    },
  };

  try {
    print('Testing with portfolioLink: ""');
    final response = await dio.post('api/v1/user/signup', data: payload);
    print('SUCCESS response status: ${response.statusCode}');
  } on DioException catch (e) {
    print('FAILED status: ${e.response?.statusCode}');
    print('FAILED data: ${e.response?.data}');
  }
}
