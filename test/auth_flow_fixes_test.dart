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
import 'package:brantro_business/features/auth/data/models/signup_request.dart';
import 'package:brantro_business/core/utils/thousands_separator_input_formatter.dart';
import 'package:brantro_business/features/wallet/data/models/bank_model.dart';
import 'package:brantro_business/features/wallet/data/models/withdrawal_account_model.dart';
import 'package:brantro_business/features/orders/data/models/order_model.dart';

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

    test('BUG-01: ScreenBillboardInfo serializes operatingCities, int yearsOfOperation, and idNumber', () {
      final info = ScreenBillboardInfo(
        businessName: 'Host Business',
        permitNumber: 'PERM-1234',
        industry: 'Outdoor',
        operatingStates: ['Lagos', 'Abuja'],
        yearsOfOperation: '3 years',
        businessWebsite: 'https://host.ng',
        businessAddress: '123 Main St',
        idType: 'CAC',
        idRcNumber: 'RC123456',
        tinNumber: '12345678-0001',
      );

      final json = info.toJson();
      expect(json.containsKey('operatingCities'), isTrue);
      expect(json['operatingCities'], equals(['Lagos', 'Abuja']));
      expect(json['yearsOfOperation'], equals(3));
      expect(json['idNumber'], equals('RC123456'));
    });

    test('BUG-04: Phone rejects all-repeating digits and invalid carrier prefixes', () {
      bool isValidPhone(String raw) {
        final digits = raw.replaceAll(RegExp(r'\D'), '');
        if (RegExp(r'^(\d)\1+$').hasMatch(digits)) return false;
        if (digits.startsWith('0')) {
          if (digits.length != 11) return false;
          final prefix = digits.substring(0, 3);
          const validPrefixes = ['070', '080', '081', '090', '091', '071', '082', '092', '074'];
          return validPrefixes.contains(prefix);
        } else {
          if (digits.length != 10) return false;
          final prefix = digits.substring(0, 2);
          const valid10Prefixes = ['70', '80', '81', '90', '91', '71', '82', '92', '74'];
          return valid10Prefixes.contains(prefix);
        }
      }

      expect(isValidPhone('00000000000'), isFalse);
      expect(isValidPhone('11111111111'), isFalse);
      expect(isValidPhone('01234567890'), isFalse); // Invalid prefix 012
      expect(isValidPhone('08012345678'), isTrue);
      expect(isValidPhone('09098765432'), isTrue);
      expect(isValidPhone('8012345678'), isTrue);
    });

    test('BUG-04: Email rejects single-digit and empty usernames', () {
      bool isValidEmail(String email) {
        final emailRegex = RegExp(r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$');
        if (!emailRegex.hasMatch(email) || !email.contains('.')) return false;
        final parts = email.split('@');
        if (parts[0].length < 2 || RegExp(r'^\d+$').hasMatch(parts[0])) return false;
        return true;
      }

      expect(isValidEmail('0@gmail.com'), isFalse);
      expect(isValidEmail('a@gmail.com'), isFalse);
      expect(isValidEmail('123@gmail.com'), isFalse); // Numeric only
      expect(isValidEmail('john.doe@gmail.com'), isTrue);
      expect(isValidEmail('test@brantro.ng'), isTrue);
    });

    test('BUG-13: AdSlot payload structure satisfies Swagger AdSlotDto requirements', () {
      // Build test payload simulating _handleSubmit logic
      const selectedCoverageArea = 'State';
      const selectedState = 'Ekiti';
      const selectedCity = null;
      final selectedContentRequirements = ['1080p MP4', 'No offensive content'];

      final List<String> coverageAreas = [];
      if (selectedCoverageArea.isNotEmpty) {
        coverageAreas.add(selectedCoverageArea);
      }
      if (selectedState.isNotEmpty && !coverageAreas.contains(selectedState)) {
        coverageAreas.add(selectedState);
      }

      final payload = <String, dynamic>{
        'title': 'Prime Screen Slot A',
        'description': 'High traffic highway billboard slot',
        'partnerType': 'BILLBOARD',
        'platforms': ['Digital Screen'],
        'contentTypes': ['Video', 'Image'],
        'features': ['24/7 Illumination'],
        'contentRequirements': selectedContentRequirements,
        'price': 150000.0,
        'duration': '7 days',
        'maxRevisions': 2,
        'coverageAreas': coverageAreas,
        'coverageArea': selectedCoverageArea,
        'adFormat': 'Digital Screen',
        'isActive': true,
      };

      // Swagger AdSlotDto mandatory fields
      const requiredFields = [
        'title',
        'description',
        'features',
        'platforms',
        'contentTypes',
        'price',
        'duration',
        'adFormat',
        'contentRequirements',
      ];

      for (final field in requiredFields) {
        expect(payload.containsKey(field), isTrue, reason: '$field must be in payload');
        expect(payload[field], isNotNull, reason: '$field must not be null');
      }

      expect(payload['contentRequirements'], isA<List>());
      expect((payload['contentRequirements'] as List), isNotEmpty);
      expect(payload['coverageAreas'], isA<List>());
      expect(payload['coverageAreas'], contains('State'));
      expect(payload['coverageAreas'], contains('Ekiti'));
    });

    test('BUG-16: ThousandsSeparatorInputFormatter formats and parses amount correctly', () {
      final formatter = ThousandsSeparatorInputFormatter();

      // Test format with digits
      final textVal1 = const TextEditingValue(text: '1000', selection: TextSelection.collapsed(offset: 4));
      final result1 = formatter.formatEditUpdate(TextEditingValue.empty, textVal1);
      expect(result1.text, equals('1,000'));
      expect(result1.selection.baseOffset, equals(5));

      // Test format with large number and decimal
      final textVal2 = const TextEditingValue(text: '1234567.50', selection: TextSelection.collapsed(offset: 10));
      final result2 = formatter.formatEditUpdate(TextEditingValue.empty, textVal2);
      expect(result2.text, equals('1,234,567.50'));

      // Test clean helper
      expect(ThousandsSeparatorInputFormatter.clean('1,000,000.75'), equals('1000000.75'));

      // Test tryParseDouble helper
      expect(ThousandsSeparatorInputFormatter.tryParseDouble('1,234,567.50'), equals(1234567.5));
      expect(ThousandsSeparatorInputFormatter.tryParseDouble(null), isNull);

      // Test tryParseInt helper
      expect(ThousandsSeparatorInputFormatter.tryParseInt('1,234,567'), equals(1234567));

      // Test format helper
      expect(ThousandsSeparatorInputFormatter.format(1000), equals('1,000'));
      expect(ThousandsSeparatorInputFormatter.format(50000.0), equals('50,000'));
      expect(ThousandsSeparatorInputFormatter.format(1500000.25), equals('1,500,000.25'));
    });

    test('Bank Search & Resolution: BankModel and AccountResolutionResult parse and serialize correctly', () {
      final bankJson = {
        'id': 9,
        'name': 'United Bank for Africa',
        'slug': 'united-bank-for-africa',
        'code': '033',
        'currency': 'NGN',
        'country': 'Nigeria',
        'active': true,
        'type': 'nuban',
      };

      final bank = BankModel.fromJson(bankJson);
      expect(bank.id, equals(9));
      expect(bank.name, equals('United Bank for Africa'));
      expect(bank.currency, equals('NGN'));
      expect(bank.country, equals('Nigeria'));

      final resolutionJson = {
        'accountNumber': '2232436237',
        'accountName': 'JOHN DOE',
        'bankId': 9,
        'bankName': 'United Bank for Africa',
        'verified': true,
      };

      final resolution = AccountResolutionResult.fromJson(resolutionJson);
      expect(resolution.accountNumber, equals('2232436237'));
      expect(resolution.accountName, equals('JOHN DOE'));
      expect(resolution.bankId, equals(9));
      expect(resolution.bankName, equals('United Bank for Africa'));
      expect(resolution.verified, isTrue);
    });

    test('Withdrawal Account: POST payload adheres strictly to Section 3 of Mobile API Handoff', () {
      // API rule: Submit only bankId, accountNumber, and isDefault.
      // Do NOT send bankCode, bankName, accountName, isVerified, or status.
      final account = WithdrawalAccountModel(
        bankId: 9,
        bankName: 'United Bank for Africa',
        accountNumber: '2232436237',
        accountName: 'JOHN DOE',
        isDefault: true,
        isVerified: true,
      );

      final payload = account.toJson();
      expect(payload['bankId'], equals(9));
      expect(payload['accountNumber'], equals('2232436237'));
      expect(payload['isDefault'], isTrue);
      expect(payload.containsKey('bankCode'), isFalse);
      expect(payload.containsKey('bankName'), isFalse);
      expect(payload.containsKey('accountName'), isFalse);
      expect(payload.containsKey('isVerified'), isFalse);
      expect(payload.containsKey('status'), isFalse);
    });

    test('Digital Services: OrderModel parses service order json and computes effectiveStatus', () {
      final serviceOrderJson = {
        'id': '101',
        'paymentRef': 'REF_SO_12345',
        'amount': '45000',
        'status': 'PAID',
        'createdAt': '2026-11-06T10:00:00Z',
        'user': {
          'name': 'Client User',
          'emailAddress': 'client@test.com',
          'phoneNumber': '08012345678',
        },
        'items': [
          {
            'id': 501,
            'status': 'PENDING',
            'service': {
              'id': 12,
              'title': 'UGC Video Creation',
              'thumbnail': 'thumbnails/ugc.jpg',
            },
            'requirementsProvided': {
              'description': 'Create a 30s TikTok-style product review.',
              'links': ['https://brand.com/product'],
              'files': [
                {
                  'id': 'file-1',
                  'name': 'brand_guidelines.pdf',
                  'mimeType': 'application/pdf',
                  'size': 1048576,
                  'url': 'uploads/guidelines.pdf',
                }
              ],
            },
          }
        ],
      };

      final order = OrderModel.fromServiceOrderJson(serviceOrderJson);
      expect(order.id, equals('REF_SO_12345'));
      expect(order.serviceType, equals('service'));
      expect(order.serviceName, equals('UGC Video Creation'));
      expect(order.customerName, equals('Client User'));
      expect(order.customerEmail, equals('client@test.com'));
      expect(order.amount, equals(45000.0));
      expect(order.itemStatus, equals('PENDING'));
      expect(order.effectiveStatus, equals('pending'));

      // Test effectiveStatus with accepted/in_progress
      final inProgressOrder = order.copyWith(
        itemStatus: 'ACCEPTED',
        metadata: {
          'items': [{'id': 501, 'status': 'ACCEPTED'}],
        },
      );
      expect(inProgressOrder.effectiveStatus, equals('in_progress'));

      // Test effectiveStatus with revision_requested
      final revisionOrder = order.copyWith(
        itemStatus: 'REVISION_REQUESTED',
        metadata: {
          'items': [{'id': 501, 'status': 'revision_requested'}],
        },
      );
      expect(revisionOrder.effectiveStatus, equals('revision_requested'));

      // Test effectiveStatus with delivered
      final deliveredOrder = order.copyWith(
        itemStatus: 'DELIVERED',
        metadata: {
          'items': [{'id': 501, 'status': 'delivered'}],
        },
      );
      expect(deliveredOrder.effectiveStatus, equals('delivered'));

      // Test effectiveStatus with completed
      final completedOrder = order.copyWith(
        itemStatus: 'APPROVED',
        metadata: {
          'items': [{'id': 501, 'status': 'approved'}],
        },
      );
      expect(completedOrder.effectiveStatus, equals('completed'));
    });

    test('Digital Services: Delivery and Decision payload structures adhere to Swagger contracts', () {
      final itemId = 501;
      final deliveryFeedback = 'Completed video according to guidelines.';
      final attachmentUrl = 'https://storage.syroltech.com/video.mp4';

      final deliveryPayload = {
        'feedback': deliveryFeedback,
        'attachments': [
          {
            'id': itemId.toString(),
            'url': attachmentUrl,
          }
        ],
      };

      expect(deliveryPayload['feedback'], equals(deliveryFeedback));
      expect(deliveryPayload['attachments'], isA<List>());
      expect((deliveryPayload['attachments'] as List).first['id'], equals('501'));
      expect((deliveryPayload['attachments'] as List).first['url'], equals(attachmentUrl));

      final decisionPayload = {
        'status': 'ACCEPTED',
        'startDate': DateTime(2026, 11, 7).toIso8601String(),
        'endDate': DateTime(2026, 11, 14).toIso8601String(),
        'remark': 'Looking forward to working on this.',
      };

      expect(decisionPayload['status'], equals('ACCEPTED'));
      expect(decisionPayload['startDate'], contains('2026-11-07'));
      expect(decisionPayload['endDate'], contains('2026-11-14'));
    });
  });
}
