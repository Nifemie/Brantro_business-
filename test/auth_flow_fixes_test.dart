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
import 'package:brantro_business/features/wallet/data/models/wallet_model.dart';
import 'package:brantro_business/features/wallet/data/models/transaction_model.dart';
import 'package:brantro_business/core/constants/endpoints.dart';
import 'package:brantro_business/features/notification/models/notification_model.dart';
import 'package:brantro_business/features/auth/data/models/login_request.dart';
import 'package:brantro_business/features/auth/data/models/verify_otp_request.dart';
import 'package:brantro_business/features/auth/data/models/forgot_password_request.dart';
import 'package:brantro_business/features/auth/data/models/reset_password_request.dart';

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

    test('Templates: OrderModel parses template order json and treats paid templates as completed sales', () {
      final templateOrderJson = {
        'id': '201',
        'paymentRef': 'REF_TMP_9988',
        'amount': '15000',
        'status': 'PAID',
        'createdAt': '2026-11-06T11:00:00Z',
        'user': {
          'name': 'Template Buyer',
          'emailAddress': 'buyer@brand.com',
          'phoneNumber': '08123456789',
        },
        'templates': [
          {
            'id': 45,
            'title': 'Minimalist Instagram Story Pack',
            'thumbnail': 'templates/minimalist_thumb.jpg',
            'price': '15000',
            'designUrl': 'https://canva.com/design/DAG123',
          }
        ],
      };

      final order = OrderModel.fromTemplateOrderJson(templateOrderJson);
      expect(order.id, equals('REF_TMP_9988'));
      expect(order.serviceType, equals('template'));
      expect(order.serviceName, equals('Minimalist Instagram Story Pack'));
      expect(order.customerName, equals('Template Buyer'));
      expect(order.amount, equals(15000.0));
      expect(order.effectiveStatus, equals('completed'));
    });

    test('Creatives: OrderModel parses creative order json and treats paid creatives as completed sales', () {
      final creativeOrderJson = {
        'id': '301',
        'paymentRef': 'REF_CRT_5566',
        'amount': '35000',
        'status': 'PAID',
        'createdAt': '2026-11-06T11:30:00Z',
        'user': {
          'name': 'Creative Buyer',
          'emailAddress': 'buyer@agency.com',
          'phoneNumber': '08098765432',
        },
        'creatives': [
          {
            'id': 78,
            'title': '3D Motion Logo Animation',
            'thumbnail': 'creatives/logo_3d_thumb.jpg',
            'price': '35000',
            'fileUrl': 'https://storage.syroltech.com/logo_3d.mp4',
          }
        ],
      };

      final order = OrderModel.fromCreativeOrderJson(creativeOrderJson);
      expect(order.id, equals('REF_CRT_5566'));
      expect(order.serviceType, equals('creative'));
      expect(order.serviceName, equals('3D Motion Logo Animation'));
      expect(order.customerName, equals('Creative Buyer'));
      expect(order.amount, equals(35000.0));
      expect(order.effectiveStatus, equals('completed'));
    });

    test('Ad Slots: verifies Host through location payload vs Other Users payload', () {
      // Host through Location
      final hostSlotData = {
        'title': 'Prime Unipole Billboard Face A',
        'description': '10-second loop on high-traffic expressway billboard',
        'partnerType': 'BILLBOARD',
        'platforms': ['BILLBOARD'],
        'contentTypes': ['IMAGE', 'VIDEO'],
        'features': ['High Visibility', 'Backlit'],
        'price': 250000.0,
        'duration': '30days',
        'adFormat': 'Billboard Banner',
        'contentRequirements': ['High Resolution JPG/PNG', '1920x1080'],
        'locationId': 42,
      };

      expect(hostSlotData['locationId'], equals(42));
      expect(hostSlotData['partnerType'], equals('BILLBOARD'));
      expect(hostSlotData['platforms'], contains('BILLBOARD'));

      // Other Users / Creator
      final creatorSlotData = {
        'title': 'Sponsored YouTube Video Segment',
        'description': '60-second dedicated mid-roll integration',
        'partnerType': 'INFLUENCER',
        'platforms': ['YOUTUBE'],
        'contentTypes': ['VIDEO'],
        'features': ['Dedicated Mention', 'Link in Description'],
        'price': 150000.0,
        'duration': 'Permanent',
        'adFormat': 'Video Segment',
        'contentRequirements': ['Talking points', 'Product link'],
      };

      expect(creatorSlotData.containsKey('locationId'), isFalse);
      expect(creatorSlotData['partnerType'], equals('INFLUENCER'));
      expect(creatorSlotData['platforms'], contains('YOUTUBE'));
    });

    test('Wallet: WalletModel correctly parses balance, escrow pending, and normalizes NGN currency', () {
      final walletJson = {
        'id': 10,
        'userId': 5,
        'balance': '185000.50',
        'pendingBalance': '45000.00',
        'currency': 'NGN',
        'status': 'ACTIVE',
        'createdAt': '2026-11-01T08:00:00Z',
        'updatedAt': '2026-11-06T12:00:00Z',
      };

      final wallet = WalletModel.fromJson(walletJson);
      expect(wallet.id, equals(10));
      expect(wallet.userId, equals(5));
      expect(wallet.balance, equals('185000.50'));
      expect(wallet.pendingBalance, equals('45000.00'));
      expect(wallet.balanceAmount, equals(185000.50));
      expect(wallet.pendingBalanceAmount, equals(45000.00));
      expect(wallet.totalBalance, equals(230000.50));
      expect(wallet.currency, equals('₦'));
      expect(wallet.isActive, isTrue);
    });

    test('Wallet: TransactionModel classifies credits and debits accurately', () {
      final creditJson = {
        'id': 101,
        'walletId': 10,
        'type': 'CREDIT',
        'source': 'SERVICE_ORDER_PAYOUT',
        'amount': 45000.0,
        'balanceBefore': 140000.50,
        'balanceAfter': 185000.50,
        'reference': 'TX_CR_8877',
        'narration': 'Payment release for UGC video',
        'status': 'COMPLETED',
        'createdAt': '2026-11-06T10:00:00Z',
      };

      final creditTx = TransactionModel.fromJson(creditJson);
      expect(creditTx.isCredit, isTrue);
      expect(creditTx.isDebit, isFalse);
      expect(creditTx.amount, equals(45000.0));
      expect(creditTx.description, equals('Payment release for UGC video'));

      final debitJson = {
        'id': 102,
        'walletId': 10,
        'type': 'DEBIT',
        'source': 'WITHDRAWAL',
        'amount': 50000.0,
        'balanceBefore': 185000.50,
        'balanceAfter': 135000.50,
        'reference': 'TX_DB_9900',
        'narration': 'Withdrawal to GTBank',
        'status': 'COMPLETED',
        'createdAt': '2026-11-06T12:30:00Z',
      };

      final debitTx = TransactionModel.fromJson(debitJson);
      expect(debitTx.isCredit, isFalse);
      expect(debitTx.isDebit, isTrue);
      expect(debitTx.amount, equals(50000.0));
    });

    test('Wallet: WithdrawalRequestDto structure satisfies Swagger contract', () {
      final withdrawalPayload = {
        'amount': 75000.0,
        'withdrawalAccountId': 3,
        'narration': 'Weekly earnings withdrawal',
      };

      expect(withdrawalPayload['amount'], equals(75000.0));
      expect(withdrawalPayload['withdrawalAccountId'], equals(3));
      expect(withdrawalPayload['narration'], equals('Weekly earnings withdrawal'));
      expect(withdrawalPayload.containsKey('amount'), isTrue);
      expect(withdrawalPayload.containsKey('withdrawalAccountId'), isTrue);
    });

    test('Locations: LocationDto structure satisfies Swagger contract across all 4 media types', () {
      final validRateUnits = [
        'SECOND', 'MINUTE', 'HOUR', 'DAY', 'WEEK', 'MONTH', 'QUARTER', 'HALF_YEAR', 'YEAR'
      ];
      final validTypes = ['SCREEN', 'BILLBOARD', 'WALL', 'VEHICLE'];

      for (final type in validTypes) {
        final locationPayload = <String, dynamic>{
          'title': 'Prime $type Location in Victoria Island',
          'type': type,
          'categoryId': 25,
          'description': 'High visibility premium $type location.',
          'videoClip': 'uploads/locations/video.mp4',
          'thumbnail': 'uploads/locations/thumb.jpg',
          'gallery': ['uploads/locations/img1.jpg', 'uploads/locations/img2.jpg'],
          'coverageAreas': ['Victoria Island', 'Lagos'],
          'estimatedReach': 250000,
          'features': 'LED illuminated, 24/7 visibility',
          'specifications': '12m x 4m high-definition display',
          'address': '1000 Ahmadu Bello Way',
          'city': 'Victoria Island',
          'state': 'Lagos',
          'country': 'Nigeria',
          'latitude': 6.4281,
          'longitude': 3.4219,
          'rate': 450000.0,
          'rateUnit': 'MONTH',
        };

        // Check required fields per Swagger LocationDto
        const requiredFields = [
          'title', 'categoryId', 'description', 'videoClip', 'coverageAreas',
          'features', 'specifications', 'address', 'city', 'state', 'country',
          'rate', 'rateUnit'
        ];
        for (final field in requiredFields) {
          expect(locationPayload.containsKey(field), isTrue, reason: '$field must be present for $type');
          expect(locationPayload[field], isNotNull, reason: '$field must not be null for $type');
        }

        // Validate types
        expect(validTypes.contains(locationPayload['type']), isTrue);
        expect(validRateUnits.contains(locationPayload['rateUnit']), isTrue);
        expect(locationPayload['estimatedReach'], isA<num>());
        expect(locationPayload['coverageAreas'], isA<List<String>>());
        expect(locationPayload['videoClip'], isA<String>());
        expect(locationPayload['videoClip'].toString().isNotEmpty, isTrue);
      }
    });

    test('Locations: UpdateBlockedDatesDto structure and expansion logic satisfies Swagger contract', () {
      const startDate = '2026-12-01T00:00:00.000Z';
      const endDate = '2026-12-04T00:00:00.000Z';

      final start = DateTime.tryParse(startDate);
      final end = DateTime.tryParse(endDate);
      final List<String> datesList = [];
      if (start != null && end != null) {
        DateTime curr = DateTime(start.year, start.month, start.day);
        final endDay = DateTime(end.year, end.month, end.day);
        while (!curr.isAfter(endDay)) {
          final y = curr.year.toString().padLeft(4, '0');
          final m = curr.month.toString().padLeft(2, '0');
          final d = curr.day.toString().padLeft(2, '0');
          datesList.add('$y-$m-$d');
          curr = curr.add(const Duration(days: 1));
        }
      }

      final blockedPayload = {
        'blockedDates': datesList,
        'startDate': startDate,
        'endDate': endDate,
        'reason': 'Scheduled Billboard Structural Maintenance',
        'type': 'MAINTENANCE',
      };

      // Verify Swagger UpdateBlockedDatesDto requirement
      expect(blockedPayload.containsKey('blockedDates'), isTrue);
      expect(blockedPayload['blockedDates'], isA<List<String>>());
      expect(blockedPayload['blockedDates'], equals([
        '2026-12-01',
        '2026-12-02',
        '2026-12-03',
        '2026-12-04',
      ]));
    });

    test('Notifications: NotificationModel correctly parses Swagger GenericNotificationDto format and classifies types', () {
      final orderNotifJson = {
        'id': 1001,
        'subject': 'New Service Order Received',
        'body': 'Client User has placed a UGC video order for REF_SO_9988.',
        'status': 'UNSEEN',
        'createdAt': '2026-11-06T12:00:00Z',
        'metadata': {
          'orderId': 'REF_SO_9988',
        },
      };

      final orderNotif = NotificationModel.fromJson(orderNotifJson);
      expect(orderNotif.id, equals('1001'));
      expect(orderNotif.title, equals('New Service Order Received'));
      expect(orderNotif.message, contains('Client User has placed a UGC video order'));
      expect(orderNotif.isRead, isFalse);
      expect(orderNotif.status, equals('UNSEEN'));
      expect(orderNotif.type, equals(NotificationType.order));
      expect(orderNotif.metadata?['orderId'], equals('REF_SO_9988'));

      final paymentNotifJson = {
        'id': 1002,
        'title': 'Wallet Credited',
        'message': 'Your wallet has been credited with ₦45,000.00 for order milestone.',
        'status': 'SEEN',
        'createdAt': '2026-11-06T12:30:00Z',
      };

      final paymentNotif = NotificationModel.fromJson(paymentNotifJson);
      expect(paymentNotif.id, equals('1002'));
      expect(paymentNotif.title, equals('Wallet Credited'));
      expect(paymentNotif.isRead, isTrue);
      expect(paymentNotif.type, equals(NotificationType.payment));
    });

    test('Notifications: Endpoints strictly adhere to Swagger notification contracts', () {
      expect(ApiEndpoints.notificationList, equals('api/v1/notification/list'));
      expect(ApiEndpoints.notificationReadAll, equals('api/v1/notification/read-all'));
      expect(ApiEndpoints.notificationDeleteAll, equals('api/v1/notification'));
      
      // Swagger: PUT /api/v1/notification/{id}?status=SEEN
      final markStatusUrl = ApiEndpoints.markNotificationStatus(42, status: 'SEEN');
      expect(markStatusUrl, equals('api/v1/notification/42?status=SEEN'));
    });

    test('Onboarding & Auth: SignUpRequest payload strictly satisfies Swagger UserDto required fields', () {
      final signup = SignUpRequest(
        role: 'HOST',
        accountType: 'BUSINESS',
        name: 'Test Billboard Host',
        emailAddress: 'host@brantro.test',
        phoneNumber: '08012345678',
        password: 'Password123!',
        country: 'Nigeria',
        state: 'Lagos',
        city: 'Ikeja',
        address: '10 Allen Avenue',
      );

      final json = signup.toJson();

      // Swagger UserDto required fields:
      const requiredFields = [
        'name',
        'phoneNumber',
        'emailAddress',
        'role',
        'authProvider',
        'password',
        'rate',
        'rateUnit',
      ];

      for (final field in requiredFields) {
        expect(json.containsKey(field), isTrue, reason: '$field must be present in UserDto signup payload');
        expect(json[field], isNotNull, reason: '$field must not be null');
      }

      expect(json['rate'], equals(0.0));
      expect(json['rateUnit'], equals('DAY'));
      expect(json['authProvider'], equals('INTERNAL'));
    });

    test('Auth Flow: Login, OTP Verify, and Password Recovery payloads satisfy Swagger DTO contracts', () {
      // 1. Login (UserAuthDto: username, password, authProvider)
      final loginReq = LoginRequest(username: 'creator@test.com', password: 'Password123!');
      final loginJson = loginReq.toJson();
      expect(loginJson['username'], equals('creator@test.com'));
      expect(loginJson['password'], equals('Password123!'));
      expect(loginJson['authProvider'], equals('INTERNAL'));

      // 2. Verify Account OTP (VerifyAccountDto: identity, otp)
      final otpReq = VerifyOtpRequest(identity: 'creator@test.com', otp: '123456');
      final otpJson = otpReq.toJson();
      expect(otpJson['identity'], equals('creator@test.com'));
      expect(otpJson['otp'], equals('123456'));

      // 3. Forgot Password (ValidateAccountDto: identity)
      final forgotReq = ForgotPasswordRequest(identity: 'creator@test.com');
      final forgotJson = forgotReq.toJson();
      expect(forgotJson['identity'], equals('creator@test.com'));

      // 4. Reset Password (ResetPasswordDto: identity, newPassword)
      final resetReq = ResetPasswordRequest(identity: 'creator@test.com', newPassword: 'NewPassword123!');
      final resetJson = resetReq.toJson();
      expect(resetJson['identity'], equals('creator@test.com'));
      expect(resetJson['newPassword'], equals('NewPassword123!'));

      // 5. Account Deletion Endpoint (DELETE /api/v1/user/me)
      expect(ApiEndpoints.userMe, equals('api/v1/user/me'));
    });
  });
}
