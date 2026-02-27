# Signup Handlers Refactoring

## Overview
The `account_details.dart` file was over 1100 lines and contained 13 different role-specific signup methods. This has been refactored into a cleaner, more maintainable structure.

## Structure

### Base Handler
- `base_signup_handler.dart` - Abstract base class with common utility methods
  - `extractIntValue()` - Handles dynamic integer extraction
  - `getGenresList()` - Converts dynamic data to string lists
  - `createSignupRequest()` - Abstract method each handler implements

### Role-Specific Handlers
Each role has its own handler file:
1. `artist_signup_handler.dart`
2. `advertiser_signup_handler.dart`
3. `creative_signup_handler.dart`
4. `designer_signup_handler.dart`
5. `influencer_signup_handler.dart`
6. `producer_signup_handler.dart`
7. `ugc_creator_signup_handler.dart`
8. `screen_billboard_signup_handler.dart`
9. `host_signup_handler.dart`
10. `tv_station_signup_handler.dart`
11. `radio_station_signup_handler.dart`
12. `media_house_signup_handler.dart`
13. `talent_manager_signup_handler.dart`

### Factory
- `signup_handler_factory.dart` - Returns the appropriate handler based on role

## Usage

### In the UI (account_details.dart)
```dart
final handler = SignupHandlerFactory.getHandler(widget.role);

if (handler != null) {
  final signUpRequest = await handler.createSignupRequest(
    roleData: widget.roleData,
    name: _nameController.text,
    email: _emailController.text,
    phone: _phoneController.text,
    password: _passwordController.text,
    country: _selectedCountry,
    state: _selectedState,
    city: _selectedCity,
    address: _addressController.text,
    accountType: _selectedAccountType,
    idType: _idTypeController.text,
    idNumber: _idNumberController.text,
    tinNumber: _tinNumberController.text,
  );
  
  await authNotifier.signupUser(signUpRequest);
}
```

## Benefits

1. **Separation of Concerns**: UI logic separated from business logic
2. **Maintainability**: Each role's logic is in its own file (~50 lines each)
3. **Testability**: Each handler can be unit tested independently
4. **Scalability**: Easy to add new roles without modifying existing code
5. **Readability**: Main UI file reduced from 1100+ lines to ~500 lines

## Migration

To use the refactored version:
1. Replace `account_details.dart` with `account_details_refactored.dart`
2. Rename `account_details_refactored.dart` to `account_details.dart`
3. All handler files are already in place

## File Sizes
- Original: `account_details.dart` - 1173 lines
- Refactored: `account_details_refactored.dart` - ~500 lines
- Each handler: ~40-60 lines
- Total: More files, but much more maintainable
