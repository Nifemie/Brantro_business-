# BRANTRO — Signup & Onboarding Complete Fixes Guide

This document contains a **detailed step-by-step reference** of all the fixes made to the Signup, Onboarding, Payload Construction, Form State, and Verification screens. You can use this guide to apply the exact same fixes to your other/main application.

---

## 1. Top-Level Role Payloads (`signup_request.dart`)

### 🔴 The Problem:
The application was previously sending role-specific information wrapped inside a generic `userInfo` object or using incorrect key names (e.g. `ugcInfo`). The backend rejected these requests with errors like:
* `"artist info should not be empty"`
* `"ugc creator info should not be empty"`

### 🟢 The Fix:
Each role's specific data **must be a top-level key** in the root JSON object, matching the exact backend property name:

```json
{
  "name": "John Doe",
  "phoneNumber": "08012345678",
  "emailAddress": "user@example.com",
  "role": "ARTIST",
  "authProvider": "EMAIL",
  "country": "Nigeria",
  "state": "Lagos",
  "city": "Ikeja",
  "address": "123 Main St",
  "password": "Password123!",
  "rate": 50000,
  "rateUnit": "SECOND",
  "artistInfo": {
    "stageName": "Big Star",
    "primaryProfession": "Musician",
    "genres": ["Afrobeats"],
    "yearsOfExperience": 5,
    "availabilityType": "FULL_TIME",
    "managementType": "SELF_MANAGED",
    "managementContact": "08012345678"
  }
}
```

### 📁 File: `lib/features/auth/data/models/signup_request.dart`

#### Top-Level `toJson()` Implementation:
```dart
Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = {
    'name': name,
    'phoneNumber': phoneNumber,
    'emailAddress': emailAddress,
    'role': role,
    'authProvider': authProvider,
    'country': country,
    if (state != null) 'state': state,
    if (city != null) 'city': city,
    if (address != null) 'address': address,
    'password': password,
    if (notificationToken != null) 'notificationToken': notificationToken,
    if (notificationDeviceType != null) 'notificationDeviceType': notificationDeviceType,
    if (authToken != null) 'authToken': authToken,
    if (rate != null) 'rate': rate,
    if (rateUnit != null) 'rateUnit': rateUnit,
  };

  // Top-level role objects (DO NOT wrap in userInfo)
  if (artistInfo != null) data['artistInfo'] = artistInfo!.toJson();
  if (ugcInfo != null) data['ugcCreatorInfo'] = ugcInfo!.toJson(); // Note: ugcCreatorInfo
  if (advertiserInfo != null) data['advertiserInfo'] = advertiserInfo!.toJson();
  if (hostInfo != null) data['hostInfo'] = hostInfo!.toJson();
  if (producerInfo != null) data['producerInfo'] = producerInfo!.toJson();
  if (influencerInfo != null) data['influencerInfo'] = influencerInfo!.toJson();
  if (designerInfo != null) data['designerInfo'] = designerInfo!.toJson();
  if (talentManagerInfo != null) data['talentManagerInfo'] = talentManagerInfo!.toJson();
  if (radioStationInfo != null) data['radioStationInfo'] = radioStationInfo!.toJson();
  if (tvStationInfo != null) data['tvStationInfo'] = tvStationInfo!.toJson();
  if (mediaHouseInfo != null) data['mediaHouseInfo'] = mediaHouseInfo!.toJson();

  return data;
}
```

#### Key Role Model Schema Fixes:
1. **`ArtistInfo`** — added `managementContact`:
```dart
class ArtistInfo {
  final String stageName;
  final String primaryProfession;
  final List<String> genres;
  final int yearsOfExperience;
  final String availabilityType;
  final String managementType;
  final String? managementContact;

  ArtistInfo({
    required this.stageName,
    required this.primaryProfession,
    required this.genres,
    required this.yearsOfExperience,
    required this.availabilityType,
    required this.managementType,
    this.managementContact,
  });

  Map<String, dynamic> toJson() => {
    'stageName': stageName,
    'primaryProfession': primaryProfession,
    'genres': genres,
    'yearsOfExperience': yearsOfExperience,
    'availabilityType': availabilityType,
    'managementType': managementType,
    if (managementContact != null && managementContact!.isNotEmpty)
      'managementContact': managementContact,
  };
}
```

2. **`UGCInfo`** — added `numberOfProjects` & renamed payload key to `ugcCreatorInfo`:
```dart
class UGCInfo {
  final List<String> contentTypes;
  final List<String> preferredPlatforms;
  final List<String> industriesOfFocus;
  final int? numberOfProjects;
  final String? portfolioUrl;

  UGCInfo({
    required this.contentTypes,
    required this.preferredPlatforms,
    required this.industriesOfFocus,
    this.numberOfProjects,
    this.portfolioUrl,
  });

  Map<String, dynamic> toJson() => {
    'contentTypes': contentTypes,
    'preferredPlatforms': preferredPlatforms,
    'industriesOfFocus': industriesOfFocus,
    if (numberOfProjects != null) 'numberOfProjects': numberOfProjects,
    if (portfolioUrl != null) 'portfolioUrl': portfolioUrl,
  };
}
```

---

## 2. Form Controller Pre-Initialization (`role_form_state_manager.dart`)

### 🔴 The Problem:
When the user navigated between role form steps, dropdowns and multi-select fields did not initialize controllers in `RoleFormStateManager`. When the form was submitted, those field values were `null`/empty, causing missing payload data.

### 🟢 The Fix:
Ensure all form fields defined in `RoleFormConfig` (text, dropdown, multiselect, numbers) pre-initialize their controllers properly.

### 📁 File: `lib/features/auth/logic/role_form_state_manager.dart`
```dart
void initializeForConfig(RoleFormConfig config) {
  _controllers.clear();
  for (final field in config.fields) {
    if (!_controllers.containsKey(field.key)) {
      _controllers[field.key] = TextEditingController(
        text: field.defaultValue?.toString() ?? '',
      );
    }
  }
}
```

---

## 3. Field Key Mappings (`artist_form_config.dart`)

### 🔴 The Problem:
`artist_form_config.dart` had a key name mismatch (`availability` vs `availabilityType`). The form saved under `availability`, but the signup handler was looking for `availabilityType`, resulting in `null`.

### 🟢 The Fix:
### 📁 File: `lib/features/auth/logic/role_form_configs/artist_form_config.dart`
```dart
// Ensure key matches the model property name:
FormFieldConfig(
  key: 'availabilityType', // Was 'availability'
  label: 'Availability Type',
  type: FormFieldType.dropdown,
  options: ['FULL_TIME', 'PART_TIME', 'WEEKENDS', 'ON_DEMAND'],
  isRequired: true,
),
```

---

## 4. Riverpod State Modification Crash in `initState` (`verify_identity.dart`)

### 🔴 The Problem:
When navigating to the OTP verification screen, the app crashed with:
> `Unhandled Exception: At least listener of the StateNotifier Instance of 'AuthNotifier' threw an exception... Tried to modify a provider while the widget tree was building.`

`_sendOtpOnLoad()` was executing inside `initState()`, triggering a state change on `authNotifierProvider` while Flutter was still mounting the widget tree.

### 🟢 The Fix:
Wrap `_sendOtpOnLoad()` inside `WidgetsBinding.instance.addPostFrameCallback` so it executes **after** the first frame is fully rendered.

### 📁 File: `lib/features/auth/presentation/onboarding/signup/verify_identity.dart`
```dart
@override
void initState() {
  super.initState();
  _startResendTimer();
  listenForCode(); // listens for autofill/paste

  // ✅ FIX: Defer OTP send until after the widget tree is fully built
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _sendOtpOnLoad();
  });
}
```

---

## 5. Summary Checklist of Backend Role Keys

When building signup payloads, use these exact top-level keys for each role:

## 5. Summary Checklist of Backend Role Keys

When building signup payloads, use these exact top-level keys for each role:

| UI Role Name | Backend Role (`role`) | Backend Payload Key | Handler Class | Model Class |
| :--- | :--- | :--- | :--- | :--- |
| **Artist** | `ARTIST` | `artistInfo` | `ArtistSignupHandler` | `ArtistInfo` |
| **UGC Creator** | `UGC_CREATOR` | `ugcCreatorInfo` | `UGCCreatorSignupHandler` | `UGCInfo` |
| **Screen / Billboard** | `HOST` | `hostInfo` | `ScreenBillboardSignupHandler` | `ScreenBillboardInfo` |
| **Host** | `HOST` | `hostInfo` | `HostSignupHandler` | `HostInfo` |
| **Advertiser** | `ADVERTISER` | `advertiserInfo` | `AdvertiserSignupHandler` | `AdvertiserInfo` |
| **Content Producer** | `PRODUCER` | `producerInfo` | `ProducerSignupHandler` | `ContentProducerInfo` |
| **Influencer** | `INFLUENCER` | `influencerInfo` | `InfluencerSignupHandler` | `InfluencerInfo` |
| **Designer** | `CREATOR` | `creativeInfo` / `designerInfo` | `DesignerSignupHandler` | `DesignerInfo` |
| **Creatives** | `CREATOR` | `creativeInfo` | `CreativeSignupHandler` | `CreativeInfo` |
| **Talent Manager** | `TALENT_MANAGER` | `talentManagerInfo` | `TalentManagerSignupHandler` | `TalentManagerInfo` |
| **Radio Station** | `RADIO_STATION` | `radioStationInfo` | `RadioStationSignupHandler` | `RadioStationInfo` |
| **TV Station** | `TV_STATION` | `tvStationInfo` | `TVStationInfo` | `TVStationInfo` |
| **Media House** | `MEDIA_HOUSE` | `mediaHouseInfo` | `MediaHouseSignupHandler` | `MediaHouseInfo` |

---

## 6. Screen / Billboard & Host Role Details (`screen_billboard_signup_handler.dart`)

### 🔴 How Screen / Billboard Works with the Backend:
In the UI, the user selects **"SCREEN / BILLBOARD"** (or **"HOST"**).
* The backend role must be **`HOST`** (`role: "HOST"`).
* The backend payload object must be **`hostInfo`** (top-level key).

### 🟢 Implementation in `screen_billboard_signup_handler.dart`:
```dart
class ScreenBillboardSignupHandler extends BaseSignupHandler {
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
    final screenBillboardInfo = ScreenBillboardInfo(
      businessName: roleData['businessName'] ?? '',
      permitNumber: roleData['permitNumber'] ?? '',
      industry: roleData['industry'] ?? '',
      operatingStates: getGenresList(roleData['operatingStates']),
      yearsOfOperation: roleData['yearsOfOperation'],
      businessWebsite: roleData['businessWebsite'],
      businessAddress: roleData['businessAddress'] ?? '',
      idType: roleData['idType'] ?? 'CAC',
      idRcNumber: roleData['idRcNumber'] ?? '',
      tinNumber: roleData['tinNumber'] ?? '',
    );

    return SignUpRequest(
      role: UserRole.HOST.value, // ✅ Sends "HOST" to backend
      authProvider: AuthProvider.INTERNAL.value,
      accountType: accountType,
      screenBillboardInfo: screenBillboardInfo,
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
```

### 🟢 Serialization in `SignUpRequest.toJson()`:
In `signup_request.dart`, `screenBillboardInfo` serializes directly under the **`hostInfo`** key so the backend receives the expected schema:
```dart
if (screenBillboardInfo != null) 'hostInfo': screenBillboardInfo!.toJson(),
if (hostInfo != null) 'hostInfo': hostInfo!.toJson(),
```

