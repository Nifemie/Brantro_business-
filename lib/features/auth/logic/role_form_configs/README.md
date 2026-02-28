# Role Form Configurations

This directory contains form field configurations for different user roles in the signup flow.

## Architecture

### Strategy Pattern
Each role has its own configuration class that extends `BaseRoleFormConfig`. This separates the form field definitions from the UI logic.

### Files

- **base_role_form_config.dart** - Abstract base class for all role configs
- **role_form_config_factory.dart** - Factory to get the right config for a role
- **[role]_form_config.dart** - Individual config files for each role

### Supported Roles

1. **Artist** - Individual only
2. **Advertiser** - Individual & Business
3. **Content Producer** - Individual & Business
4. **Influencer** - Individual only
5. **UGC Creator** - Individual only
6. **Screen / Billboard** - Business only
7. **TV Station** - Business only
8. **Radio Station** - Business only
9. **Media House** - Business only
10. **Creatives** - Individual only
11. **Talent Manager** - Individual & Business
12. **Host** - Business only

## Usage

```dart
// Get configuration for a role
final config = RoleFormConfigFactory.getConfig('Artist');

// Check if role supports account types (Individual/Business)
if (config.supportsAccountTypes) {
  // Show account type selector
}

// Get form fields for the selected account type
final fields = config.getFormFields(accountType);

// Render fields dynamically
for (var field in fields) {
  // field['name'], field['type'], field['label'], etc.
}
```

## Field Structure

Each field is a Map with the following keys:

```dart
{
  'name': 'fieldName',           // Required - field identifier
  'label': 'Field Label',        // Required - display label
  'type': 'text',                // Required - text, dropdown, multiselect, password
  'hint': 'Placeholder text',    // Optional - hint text
  'required': true,              // Optional - validation flag
  'options': [...],              // Required for dropdown/multiselect
  'dependsOn': 'otherField',     // Optional - for dependent fields (e.g., city depends on state)
}
```

## Adding a New Role

1. Create a new config file: `[role]_form_config.dart`
2. Extend `BaseRoleFormConfig`
3. Implement `getFormFields()` method
4. Add to factory in `role_form_config_factory.dart`

Example:

```dart
import 'base_role_form_config.dart';
import '../../../../core/constants/form_constants.dart';

class NewRoleFormConfig extends BaseRoleFormConfig {
  @override
  String get roleName => 'New Role';
  
  @override
  bool get supportsAccountTypes => false; // or true
  
  @override
  List<Map<String, dynamic>> getFormFields(String accountType) {
    return [
      {
        'name': 'displayName',
        'label': 'Display Name',
        'type': 'text',
        'hint': 'Enter your name',
        'required': true,
      },
      // ... more fields
    ];
  }
}
```

## Benefits

- **Maintainability**: Each role's fields are in a separate file
- **Testability**: Easy to test individual role configurations
- **Scalability**: Adding new roles doesn't bloat the main UI file
- **Reusability**: Form field definitions can be reused across the app
- **Clean Code**: Main UI file reduced from 1,448 lines to 405 lines (72% reduction)

## Related Files

- `lib/features/auth/presentation/onboarding/signup/role_details.dart` - Main UI that uses these configs
- `lib/core/constants/form_constants.dart` - Dropdown options and constants
