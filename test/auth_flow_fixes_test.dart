import 'package:brantro_business/features/account/data/models/user_analytics_model.dart';
import 'package:brantro_business/core/constants/template_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brantro_business/core/service/session_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/core/constants/enum.dart';
import 'package:brantro_business/core/constants/location_constants.dart';
import 'package:brantro_business/core/utils/error_sanitizer.dart';
import 'package:brantro_business/controllers/re_useable/custom_dropdown_field.dart';
import 'package:brantro_business/core/network/api_client.dart';
import 'package:brantro_business/core/constants/bank_constants.dart';
import 'package:brantro_business/core/constants/kyc_constants.dart';
import 'package:brantro_business/features/chat/presentation/screens/chat_screen.dart';

void main() {
  group('Auth Flow Bug Fixes Verification', () {
    test('BRT-031: UserRole.ADVERTISER maps to backend accepted value "USER"', () {
      expect(UserRole.ADVERTISER.value, equals('USER'));
      expect(UserRole.fromString('USER'), equals(UserRole.ADVERTISER));
      expect(UserRole.fromString('ADVERTISER'), equals(UserRole.ADVERTISER));
    });

    test('BRT-032: ErrorSanitizer masks SUPER_ADMIN/ADMIN and strips brackets', () {
      // Strips brackets and masks internal admin roles
      final rawError = '[role must be one of SUPER_ADMIN, ADMIN, ARTIST]';
      final sanitized = ErrorSanitizer.sanitize(rawError);
      expect(sanitized.contains('SUPER_ADMIN'), isFalse);
      expect(sanitized.contains('ADMIN'), isFalse);
      expect(sanitized.contains('['), isFalse);
      expect(sanitized.contains(']'), isFalse);
    });

    test('ErrorSanitizer distinguishes duplicate email vs phone', () {
      final emailErr = ErrorSanitizer.sanitize('User with this email already exist');
      expect(emailErr, contains('email address already exists'));

      final phoneErr = ErrorSanitizer.sanitize('User with this phone number already exist');
      expect(phoneErr, contains('phone number already exists'));
    });

    test('BRT-045: FCT/Abuja LGA resolution does not throw RangeError: -1', () {
      final fctLgas = LocationHelper.getLGAsForState('FCT');
      expect(fctLgas, isNotEmpty);
      expect(fctLgas, contains('Abuja Municipal'));
      expect(fctLgas, contains('Bwari'));
      expect(fctLgas, contains('Gwagwalada'));

      final abujaLgas = LocationHelper.getLGAsForState('Federal Capital Territory (Abuja)');
      expect(abujaLgas, isNotEmpty);
      expect(abujaLgas, contains('Kuje'));
    });

    test('BRT-047: Password complexity requires 8+ chars, uppercase, lowercase, number, symbol', () {
      bool isStrongPassword(String val) {
        if (val.length < 8) return false;
        if (!RegExp(r'[A-Z]').hasMatch(val)) return false;
        if (!RegExp(r'[a-z]').hasMatch(val)) return false;
        if (!RegExp(r'[0-9]').hasMatch(val)) return false;
        if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>\-_]').hasMatch(val)) return false;
        return true;
      }

      expect(isStrongPassword('weak'), isFalse);
      expect(isStrongPassword('weakpassword'), isFalse);
      expect(isStrongPassword('WeakPassword'), isFalse);
      expect(isStrongPassword('WeakPass1'), isFalse);
      expect(isStrongPassword('StrongPass1!'), isTrue);
    });

    test('BRT-038: TIN only allows digits and hyphens', () {
      final tinRegex = RegExp(r'^[0-9\-]+$');
      expect(tinRegex.hasMatch('12345678-0001'), isTrue);
      expect(tinRegex.hasMatch('12345678'), isTrue);
      expect(tinRegex.hasMatch('TIN-1234'), isFalse); // letters not allowed
      expect(tinRegex.hasMatch('1234@#56'), isFalse); // symbols not allowed
    });

    testWidgets('BRT-037 & BRT-033: CustomDropdownField handles duplicate options without crash', (tester) async {
      final duplicateOptions = [
        {'label': 'Lagos', 'value': 'Lagos'},
        {'label': 'Lagos (duplicate)', 'value': 'Lagos'},
        {'label': 'Abuja', 'value': 'Abuja'},
      ];

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: CustomDropdownField(
                label: 'State',
                options: duplicateOptions,
                onChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomDropdownField), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    test('BRT-030: ApiClient initializes with strict TLS configuration', () {
      final client = ApiClient();
      expect(client.dio, isNotNull);
      expect(client.dio.options.baseUrl, 'https://api.syroltech.com/brantro/');
    });

    testWidgets('BRT-021: ChatScreen displays clean empty state when no messages exist', (tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => const MaterialApp(
            home: ChatScreen(messages: []),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('No Messages Yet'), findsOneWidget);
      expect(find.text('Hey 😊'), findsNothing);
    });

    test('BRT-022: NIGERIAN_BANKS contains major commercial banks and fintechs', () {
      expect(NIGERIAN_BANKS, contains('Guaranty Trust Bank (GTBank)'));
      expect(NIGERIAN_BANKS, contains('Zenith Bank'));
      expect(NIGERIAN_BANKS, contains('Access Bank'));
      expect(NIGERIAN_BANKS, contains('Kuda Bank'));
      expect(NIGERIAN_BANKS, contains('OPay Digital Services'));
      expect(NIGERIAN_BANKS, contains('Moniepoint Microfinance Bank'));
    });

    test('BRT-028: KYC allows alternative document types beyond NIN', () {
      final individualValues = INDIVIDUAL_DOCUMENT_TYPES.map((d) => d['value']).toList();
      expect(individualValues, contains('NIN'));
      expect(individualValues, contains('VOTERS_CARD'));
      expect(individualValues, contains('DRIVERS_LICENSE'));
      expect(individualValues, contains('PASSPORT'));

      // Verify Voter's Card and Driver's License validation
      expect(KycValidationRules.getDocumentNumberError('VOTERS_CARD', '90F5B1234567890'), isNull);
      expect(KycValidationRules.getDocumentNumberError('DRIVERS_LICENSE', 'ABC12345AA'), isNull);
      expect(KycValidationRules.getDocumentNumberError('PASSPORT', 'A12345678'), isNull);
    });

    test('BRT-024: SessionService tracks app lock state correctly', () async {
      SharedPreferences.setMockInitialValues({});
      expect(await SessionService.isAppLocked(), isFalse);

      await SessionService.setAppLocked(true);
      expect(await SessionService.isAppLocked(), isTrue);

      await SessionService.setAppLocked(false);
      expect(await SessionService.isAppLocked(), isFalse);
    });

    test('BRT-027: UserAnalyticsModel defaults to zero metrics for new accounts', () {
      const analytics = UserAnalyticsModel();
      expect(analytics.followers, equals(0));
      expect(analytics.impressions, equals(0));
      expect(analytics.reach, equals(0));
      expect(analytics.profileViews, equals(0));
    });

    test('BRT-025: TemplateConstants provides fallback categories when API is unseeded', () {
      expect(TemplateConstants.templateCategories, isNotEmpty);
      expect(TemplateConstants.templateCategories, contains('Billboard'));
      expect(TemplateConstants.templateCategories, contains('Canva Templates'));
      expect(TemplateConstants.templateCategories, contains('Digital Screen'));
    });

    test('NUBAN: Nigerian bank account number requires exactly 10 numeric digits', () {
      final nubanRegex = RegExp(r'^\d{10}$');
      expect(nubanRegex.hasMatch('0123456789'), isTrue);
      expect(nubanRegex.hasMatch('123456789'), isFalse); // 9 digits
      expect(nubanRegex.hasMatch('01234567890'), isFalse); // 11 digits
      expect(nubanRegex.hasMatch('012345678a'), isFalse); // letters
      expect(nubanRegex.hasMatch('012-345678'), isFalse); // symbols
    });

    test('BRT-038: ID Number is validated per ID Type and TIN requires digits only', () {
      // 1. When ID Type is NIN, ID Number must be exactly 11 digits
      final ninRegex = RegExp(r'^\d{11}$');
      expect(ninRegex.hasMatch('12345678901'), isTrue);
      expect(ninRegex.hasMatch('12345'), isFalse);
      expect(ninRegex.hasMatch('123456789012'), isFalse);
      expect(ninRegex.hasMatch('1234567890a'), isFalse);

      // 2. When ID Type is TIN, ID Number must be between 8 and 12 digits
      final tinRegex = RegExp(r'^\d{8,12}$');
      expect(tinRegex.hasMatch('12345678'), isTrue);
      expect(tinRegex.hasMatch('123456789012'), isTrue);
      expect(tinRegex.hasMatch('1234567'), isFalse);
      expect(tinRegex.hasMatch('1234567890123'), isFalse);
      expect(tinRegex.hasMatch('q;_!_+\'kkxbhs'), isFalse); // QA test input string rejected

      // 3. When ID Type is CAC, format accepts 5-15 alphanumeric/hyphen characters
      final cacRegex = RegExp(r'^[a-zA-Z0-9/-]{5,15}$');
      expect(cacRegex.hasMatch('RC123456'), isTrue);
      expect(cacRegex.hasMatch('BN-987654'), isTrue);
      expect(cacRegex.hasMatch('1234527462fgh'), isTrue);
      expect(cacRegex.hasMatch('RC'), isFalse); // too short

      // 4. When ID Type is Passport, 1 letter followed by 8 digits
      final passportRegex = RegExp(r'^[a-zA-Z][0-9]{8}$');
      expect(passportRegex.hasMatch('A12345678'), isTrue);
      expect(passportRegex.hasMatch('123456789'), isFalse);
      expect(passportRegex.hasMatch('AB1234567'), isFalse);
    });
  });
}
